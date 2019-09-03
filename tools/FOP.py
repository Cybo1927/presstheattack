#!/usr/bin/env python
""" FOP
    Filter Orderer and Preener
    Copyright (C) 2011 Michael

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>."""

VERSION = 3.9
import collections, filecmp, os, re, subprocess, sys
MAJORREQUIRED = 3
MINORREQUIRED = 1
if sys.version_info < (MAJORREQUIRED, MINORREQUIRED):
    raise RuntimeError("FOP requires Python {reqmajor}.{reqminor} or greater, but Python {ismajor}.{isminor} is being used to run this program.".format(reqmajor = MAJORREQUIRED, reqminor = MINORREQUIRED, ismajor = sys.version_info.major, isminor = sys.version_info.minor))
from urllib.parse import urlparse
ELEMENTDOMAINPATTERN = re.compile(r"^([^\/\*\|\@\"\!]*?)#\@?#")
FILTERDOMAINPATTERN = re.compile(r"(?:\$|\,)domain\=([^\,\s]+)$")
ELEMENTPATTERN = re.compile(r"^([^\/\*\|\@\"\!]*?)(#\@?#?)([^{}]+)$")
OPTIONPATTERN = re.compile(r"^(.*)\$(~?[\w\-]+(?:=[^,\s]+)?(?:,~?[\w\-]+(?:=[^,\s]+)?)*)$")
SELECTORPATTERN = re.compile(r"(?<=[\s\[@])([a-zA-Z]*[A-Z][a-zA-Z0-9]*)((?=([\[\]\^\*\$=:@#\.]))|(?=(\s(?:[+>~]|\*|[a-zA-Z][a-zA-Z0-9]*[\[:@\s#\.]|[#\.][a-zA-Z][a-zA-Z0-9]*))))")
PSEUDOPATTERN = re.compile(r"(\:[a-zA-Z\-]*[A-Z][a-zA-Z\-]*)(?=([\(\:\@\s]))")
REMOVALPATTERN = re.compile(r"((?<=([>+~,]\s))|(?<=(@|\s|,)))(\*)(?=([#\.\[\:]))")
ATTRIBUTEVALUEPATTERN = re.compile(r"^([^\'\"\\]|\\.)*(\"(?:[^\"\\]|\\.)*\"|\'(?:[^\'\\]|\\.)*\')|\*")
TREESELECTOR = re.compile(r"(\\.|[^\+\>\~\\\ \t])\s*([\+\>\~\ \t])\s*(\D)")
UNICODESELECTOR = re.compile(r"\\[0-9a-fA-F]{1,6}\s[a-zA-Z]*[A-Z]")
BLANKPATTERN = re.compile(r"^\s*$")
COMMITPATTERN = re.compile(r"^(A|M|P)\:\s(\((.+)\)\s)?(.*)$")
IGNORE = ("CC-BY-SA.txt", "easytest.txt", "GPL.txt", "MPL.txt",
          "enhancedstats-addon.txt", "fanboy-tracking", "firefox-regional", "other")
KNOWNOPTIONS = ("collapse", "csp", "document", "elemhide",
                "font", "genericblock", "generichide", "image", "match-case",
                "object", "media", "object-subrequest", "other", "ping", "popup",
                "rewrite=abp-resource:blank-css", "rewrite=abp-resource:blank-js", "rewrite=abp-resource:blank-html", "rewrite=abp-resource:blank-mp3", "rewrite=abp-resource:blank-text",
                "rewrite=abp-resource:1x1-transparent-gif", "rewrite=abp-resource:2x2-transparent-png", "rewrite=abp-resource:3x2-transparent-png", "rewrite=abp-resource:32x32-transparent-png",
                "script", "stylesheet", "subdocument", "third-party", "websocket", "webrtc", "xmlhttprequest", "important", "first-party", "1p", "3p", "frame")
REPODEF = collections.namedtuple("repodef", "name, directory, locationoption, repodirectoryoption, checkchanges, difference, commit, pull, push")
GIT = REPODEF(["git"], "./.git/", "--work-tree=", "--git-dir=", ["status", "-s", "--untracked-files=no"], ["diff"], ["commit", "-a", "-m"], ["pull"], ["push"])
HG = REPODEF(["hg"], "./.hg/", "-R", None, ["stat", "-q"], ["diff"], ["commit", "-m"], ["pull"], ["push"])
REPOTYPES = (GIT, HG)
def start ():
    greeting = "FOP (Filter Orderer and Preener) version {version}".format(version = VERSION)
    characters = len(str(greeting))
    print("=" * characters)
    print(greeting)
    print("=" * characters)
    places = sys.argv[1:]
    if places:
        places = [os.path.abspath(place) for place in places]
        for place in sorted(set(places)):
            main(place)
            print()
    else:
        main(os.getcwd())
def main (location):
    if not os.path.isdir(location):
        print("{location} does not exist or is not a folder.".format(location = location))
        return
    repository = None
    for repotype in REPOTYPES:
        if os.path.isdir(os.path.join(location, repotype.directory)):
            repository = repotype
            break
    if repository:
        try:
            basecommand = repository.name
            if repository.locationoption.endswith("="):
                basecommand.append("{locationoption}{location}".format(locationoption = repository.locationoption, location = location))
            else:
                basecommand.extend([repository.locationoption, location])
            if repository.repodirectoryoption:
                if repository.repodirectoryoption.endswith("="):
                    basecommand.append("{repodirectoryoption}{location}".format(repodirectoryoption = repository.repodirectoryoption, location = os.path.normpath(os.path.join(location, repository.directory))))
                else:
                    basecommand.extend([repository.repodirectoryoption, location])
            command = basecommand + repository.checkchanges
            originaldifference = True if subprocess.check_output(command) else False
        except(subprocess.CalledProcessError, OSError):
            print("The command \"{command}\" was unable to run; FOP will therefore not attempt to use the repository tools. On Windows, this may be an indication that you do not have sufficient privileges to run FOP - the exact reason why is unknown. Please also ensure that your revision control system is installed correctly and understood by FOP.".format(command = " ".join(command)))
            repository = None
    print("\nPrimary location: {folder}".format(folder = os.path.join(os.path.abspath(location), "")))
    for path, directories, files in os.walk(location):
        for direct in directories[:]:
            if direct.startswith(".") or direct in IGNORE:
                directories.remove(direct)
        print("Current directory: {folder}".format(folder = os.path.join(os.path.abspath(path), "")))
        directories.sort()
        for filename in sorted(files):
            address = os.path.join(path, filename)
            extension = os.path.splitext(filename)[1]
            if extension == ".txt" and filename not in IGNORE:
                fopsort(address)
            if extension == ".orig" or extension == ".temp":
                try:
                    os.remove(address)
                except(IOError, OSError):
                    pass
    if repository:
        commit(repository, basecommand, originaldifference)
def fopsort (filename):
    temporaryfile = "{filename}.temp".format(filename = filename)
    CHECKLINES = 10
    section = []
    lineschecked = 1
    filterlines = elementlines = 0
    with open(filename, "r", encoding = "utf-8", newline = "\n") as inputfile, open(temporaryfile, "w", encoding = "utf-8", newline = "\n") as outputfile:
        def combinefilters(uncombinedFilters, DOMAINPATTERN, domainseparator):
            combinedFilters = []
            for i in range(len(uncombinedFilters)):
                domains1 = re.search(DOMAINPATTERN, uncombinedFilters[i])
                if i+1 < len(uncombinedFilters) and domains1:
                    domains2 = re.search(DOMAINPATTERN, uncombinedFilters[i+1])
                    domain1str = domains1.group(1)
                if not domains1 or i+1 == len(uncombinedFilters) or not domains2 or len(domain1str) == 0 or len(domains2.group(1)) == 0:
                    combinedFilters.append(uncombinedFilters[i])
                else:
                    domain2str = domains2.group(1)
                    if domains1.group(0).replace(domain1str, domain2str, 1) != domains2.group(0):
                        combinedFilters.append(uncombinedFilters[i])
                    elif re.sub(DOMAINPATTERN, "", uncombinedFilters[i]) == re.sub(DOMAINPATTERN, "", uncombinedFilters[i+1]):
                        newDomains = "{d1}{sep}{d2}".format(d1=domain1str, sep=domainseparator, d2=domain2str)
                        newDomains = domainseparator.join(sorted(set(newDomains.split(domainseparator)), key = lambda domain: domain.strip("~")))
                        if (domain1str.count("~") != domain1str.count(domainseparator) + 1) != (domain2str.count("~") != domain2str.count(domainseparator) + 1):
                            combinedFilters.append(uncombinedFilters[i])
                        else:
                            domainssubstitute = domains1.group(0).replace(domain1str, newDomains, 1)
                            uncombinedFilters[i+1] = re.sub(DOMAINPATTERN, domainssubstitute, uncombinedFilters[i])
                    else:
                        combinedFilters.append(uncombinedFilters[i])
            return combinedFilters
        def writefilters():
            if elementlines > filterlines:
                uncombinedFilters = sorted(set(section), key = lambda rule: re.sub(ELEMENTDOMAINPATTERN, "", rule))
                outputfile.write("{filters}\n".format(filters = "\n".join(combinefilters(uncombinedFilters, ELEMENTDOMAINPATTERN, ","))))
            else:
                uncombinedFilters = sorted(set(section), key = str.lower)
                outputfile.write("{filters}\n".format(filters = "\n".join(combinefilters(uncombinedFilters, FILTERDOMAINPATTERN, "|"))))
        for line in inputfile:
            line = line.strip()
            if not re.match(BLANKPATTERN, line):
                if line[0] == "!" or line[:8] == "%include" or line[0] == "[" and line[-1] == "]":
                    if section:
                        writefilters()
                        section = []
                        lineschecked = 1
                        filterlines = elementlines = 0
                    outputfile.write("{line}\n".format(line = line))
                else:
                    elementparts = re.match(ELEMENTPATTERN, line)
                    if elementparts:
                        domains = elementparts.group(1).lower()
                        if lineschecked <= CHECKLINES:
                            elementlines += 1
                            lineschecked += 1
                        line = elementtidy(domains, elementparts.group(2), elementparts.group(3))
                    else:
                        if lineschecked <= CHECKLINES:
                            filterlines += 1
                            lineschecked += 1
                        line = filtertidy(line)
                    section.append(line)
        if section:
            writefilters()
    if not filecmp.cmp(temporaryfile, filename):
        if os.name == "nt":
            os.remove(filename)
        os.rename(temporaryfile, filename)
        print("Sorted: {filename}".format(filename = os.path.abspath(filename)))
    else:
        os.remove(temporaryfile)
def filtertidy (filterin):
    optionsplit = re.match(OPTIONPATTERN, filterin)

    if not optionsplit:
        return removeunnecessarywildcards(filterin)
    else:
        filtertext = removeunnecessarywildcards(optionsplit.group(1))
        optionlist = optionsplit.group(2).lower().replace("_", "-").split(",")
        domainlist = []
        removeentries = []
        for option in optionlist:
            if option[0:7] == "domain=":
                domainlist.extend(option[7:].split("|"))
                removeentries.append(option)
            elif option.strip("~") not in KNOWNOPTIONS:
                print("Warning: The option \"{option}\" used on the filter \"{problemfilter}\" is not recognised by FOP".format(option = option, problemfilter = filterin))
        optionlist = sorted(set(filter(lambda option: option not in removeentries, optionlist)), key = lambda option: (option[1:] + "~") if option[0] == "~" else option)
        if domainlist:
            optionlist.append("domain={domainlist}".format(domainlist = "|".join(sorted(set(domainlist), key = lambda domain: domain.strip("~")))))
        return "{filtertext}${options}".format(filtertext = filtertext, options = ",".join(optionlist))
def elementtidy (domains, separator, selector):
    if "," in domains:
        domains = ",".join(sorted(set(domains.split(",")), key = lambda domain: domain.strip("~")))
    selector = "@{selector}@".format(selector = selector)
    each = re.finditer
    selectorwithoutstrings = selector
    selectoronlystrings = ""
    while True:
        stringmatch = re.match(ATTRIBUTEVALUEPATTERN, selectorwithoutstrings)
        if stringmatch == None: break
        selectorwithoutstrings = selectorwithoutstrings.replace("{before}{stringpart}".format(before = stringmatch.group(1), stringpart = stringmatch.group(2)), "{before}".format(before = stringmatch.group(1)), 1)
        selectoronlystrings = "{old}{new}".format(old = selectoronlystrings, new = stringmatch.group(2))
    for tree in each(TREESELECTOR, selector):
        if tree.group(0) in selectoronlystrings or not tree.group(0) in selectorwithoutstrings: continue
        replaceby = " {g2} ".format(g2 = tree.group(2))
        if replaceby == "   ": replaceby = " "
        selector = selector.replace(tree.group(0), "{g1}{replaceby}{g3}".format(g1 = tree.group(1), replaceby = replaceby, g3 = tree.group(3)), 1)
    for untag in each(REMOVALPATTERN, selector):
        untagname = untag.group(4)
        if untagname in selectoronlystrings or not untagname in selectorwithoutstrings: continue
        bc = untag.group(2)
        if bc == None:
            bc = untag.group(3)
        ac = untag.group(5)
        selector = selector.replace("{before}{untag}{after}".format(before = bc, untag = untagname, after = ac), "{before}{after}".format(before = bc, after = ac), 1)
    for tag in each(SELECTORPATTERN, selector):
        tagname = tag.group(1)
        if tagname in selectoronlystrings or not tagname in selectorwithoutstrings: continue
        if re.search(UNICODESELECTOR, selectorwithoutstrings) != None: break
        ac = tag.group(3)
        if ac == None:
            ac = tag.group(4)
        selector = selector.replace("{tag}{after}".format(tag = tagname, after = ac), "{tag}{after}".format(tag = tagname.lower(), after = ac), 1)
    for pseudo in each(PSEUDOPATTERN, selector):
        pseudoclass = pseudo.group(1)
        if pseudoclass in selectoronlystrings or not pseudoclass in selectorwithoutstrings: continue
        ac = pseudo.group(3)
        selector = selector.replace("{pclass}{after}".format(pclass = pseudoclass, after = ac), "{pclass}{after}".format(pclass = pseudoclass.lower(), after = ac), 1)
    return "{domain}{separator}{selector}".format(domain = domains, separator = separator, selector = selector[1:-1])
def commit (repository, basecommand, userchanges):
    difference = subprocess.check_output(basecommand + repository.difference)
    if not difference:
        print("\nNo changes have been recorded by the repository.")
        return
    print("\nThe following changes have been recorded by the repository:")
    try:
        print(difference.decode("utf-8"))
    except UnicodeEncodeError:
        print("\nERROR: DIFF CONTAINED UNKNOWN CHARACTER(S). Showing unformatted diff instead:\n");
        print(difference)
    try:
        while True:
            comment = input("Please enter a valid commit comment or quit:\n")
            if checkcomment(comment, userchanges):
                break
    except (KeyboardInterrupt, SystemExit):
        print("\nCommit aborted.")
        return
    print("Comment \"{comment}\" accepted.".format(comment = comment))
    try:
        command = basecommand + repository.commit + [comment]
        subprocess.Popen(command).communicate()
        print("\nConnecting to server. Please enter your password if required.")
        for command in repository[7:]:
            command = basecommand + command
            subprocess.Popen(command).communicate()
            print()
    except(subprocess.CalledProcessError):
        print("Unexpected error with the command \"{command}\".".format(command = command))
        raise subprocess.CalledProcessError("Aborting FOP.")
    except(OSError):
        print("Unexpected error with the command \"{command}\".".format(command = command))
        raise OSError("Aborting FOP.")
    print("Completed commit process successfully.")
def isglobalelement (domains):
    for domain in domains.split(","):
        if domain and not domain.startswith("~"):
            return False
    return True
def removeunnecessarywildcards (filtertext):
    whitelist = False
    hadStar = False
    if filtertext[0:2] == "@@":
        whitelist = True
        filtertext = filtertext[2:]
    while len(filtertext) > 1 and filtertext[1] == "*" and not filtertext[1] == "|" and not filtertext[1] == "!":
        filtertext = filtertext[1:]
        hadStar = True
    while len(filtertext) > 1 and filtertext[-1] == "*" and not filtertext[-2] == "|" and not filtertext[-2] == " ": 
        filtertext = filtertext[:-1]
        hadStar = True
    if hadStar and filtertext[0] == "/" and filtertext[-1] == "/":
        filtertext = "{filtertext}*".format(filtertext = filtertext)
    if filtertext == "*":
        filtertext = ""
    if whitelist:
        filtertext = "@@{filtertext}".format(filtertext = filtertext)
    return filtertext
def checkcomment(comment, changed):
    sections = re.match(COMMITPATTERN, comment)
    if sections == None:
        print("The comment \"{comment}\" is not in the recognised format.".format(comment = comment))
    else:
        indicator = sections.group(1)
        if indicator == "M":
            return True
        elif indicator == "A" or indicator == "P":
            if not changed:
                print("You have indicated that you have added or removed a rule, but no changes were initially noted by the repository.")
            else:
                address = sections.group(4)
                if not validurl(address):
                    print("Unrecognised address \"{address}\".".format(address = address))
                else:
                    return True
    print()
    return False
def validurl (url):
    addresspart = urlparse(url)
    if addresspart.scheme and addresspart.netloc and addresspart.path:
        return True
    elif addresspart.scheme == "about":
        return True
    else:
        return False
if __name__ == '__main__':
    start()