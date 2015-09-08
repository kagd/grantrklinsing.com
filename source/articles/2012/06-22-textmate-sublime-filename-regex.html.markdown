---
title: TextMate & Sublime Filename Regex
date: 2012-06-22 05:24 UTC
tags: textmate, sublime text
---

I love using snippets in [TextMate](http://macromates.com)(TM) and [Sublime Text 2](http://www.sublimetext.com)(ST2). They have sped up my work a lot especially when creating similar files over and over again and they have come in quite handy when creating blog posts also.

I use an open source blogging framework to create posts, [MicrowaveJS](https://github.com/tstone/MicrowaveJS). And, since this framework is targeted at developers, I must create a new markdown file each time i want to write a new post. One of the conventions of this framework is creating a YAML file config at the top of each post. Similar to this:

READMORE

```md
/*
title: Helpful TextMate & Sublime Text 2 Filename Snippet
Date: June 22, 2012
Tags: [text editor, sublime text 2, textmate]
comments: true
*/
```

This YAML config defines the properties of this file. The title, date you want to publish, tags, and whether or not you should see comments. Now, I could write this out over and over again when creating posts, but why when there are snippets to speed things up. You will notice that there is a *title* attribute in this config. This *title* can be anything I want, but I want it to always be the same as the file name, with a couple of exceptions. It should be the file name with no hyphenation and file extension and capitalize the first character of each word.

At first I didn't think this was possible with snippets but I recently learned that there are variables available within the editor. In particular, `$TM_FILENAME`. This gives you access to the file name from within a snippet. Since this is a bit more of an advanced post on snippets, I am going to assume you know the basics of TM and ST2 snippets. Here is my base snippet:

```xml
<![CDATA[/*
title: ${1:${TM_FILENAME}}
Date: ${2:April} ${3:4}, 201${4:2}
Tags: [${5:javascript, jquery}]
comments: ${6:true}
*/
]]>
```

Step one, add the file name to the config, check. Step two, parse the file name into the correct format. We will do this with regular expression replacement. Now, I know what you are saying, "the person who solves a problem with regex now has two problems". While that may be true, that is the method TM and ST2 use to transform variables.

My file names follow a convention, name-with-hyphens.md. So, the first thing that I need to do is remove all the hyphens

```md
${1:${TM_FILENAME/-/ /g}}
// -> helpful textmate & sublime text 2 filename snippet.md
```

Here is how this works. `TM_FILENAME` is the variable that the regex replacement will run on. Everything within the first two slashes is your matching regex. So, in this case, we are just matching on hyphens. Everything between the second and third slashes is the replacement. And in this case, it's just an empty space. The trailing `g` is same as a normal regex, search globally.

Now, let's replace the extension

```md
${1:${TM_FILENAME/-|.md/ /g}}
// -> helpful textmate & sublime text 2 filename snippet
```

Here's the fun part, take each word an capitalize it

```md
${1:${TM_FILENAME/([\w&]+)-?(.md)?/\u$1 /g}}
// -> Helpful Textmate & Sublime Text 2 Filename Snippet
```

You'll notice that we change up the regex quite a bit. That's because we need to grab the words rather than just remove some things. First, we grab all the 'word' characters `([\w]+)` and store them in a group for reference later. Next, we have to check for the use of hyphens or the extension to strip them out. For the replacement, `\u` capitalizes what is directly after is. In this case, we are capitalizing the group that we saved earlier. Then add a space in between the words. TADA! We have a string that is titlized and in the correct format.

But wait! Why is there a trailing space? You can not tell in this post, but there is a trailing space at the end of the title. Remember how we added a space on the replacement of a match? This is a remnant of that space on the last replaced match. So, how do we get rid of it? Well, within the TM and ST2 regex system, there is the concept of conditionals. We can just check to see if it the last match.

```md
${1:${TM_FILENAME/([\w&]+)-?(.md)?/\u$1(?2:: )/g}}
// -> Helpful Textmate &-Sublime Text 2 Filename Snippet
```

Since we are already capturing a second group within out regex (`(.md)`), we can test our conditional against that. Here is how the conditional looks: `(?2:: )`. `?2` is asking 'is there a second match?'. This will only be true in the case of the last word since it is followed by the file extension. What's following the first colon is what to substitute is a second match exists. If however a second match is not met, whatever follows the second colon is substituted. That is all just a long winded way of saying, 'add a space if this is not the last word of the file'.

So when it is all said and done, here is the whole snippet.

```xml
<![CDATA[/*
title: ${1:${TM_FILENAME/([\w&]+)-?(.md)?/\u$1(?2:: )/g}}
Date: ${2:April} ${3:4}, 201${4:2}
Tags: [${5:javascript, jquery}]
comments: ${6:true}
*/
]]>
```
