Demonstrator's Toolkit (DTK)
======================

A toolkit to aide demonstrators at Aberystwyth University's CompSci department queue amongst other cool tools

So what is this anyway?
-----------------------
Demonstrator's toolkit was a hack one Monday morning when I had no lectures or work on to learn more about node and socket.io. However this tries to resolve an issue which demonstrators at Aber Uni CompSci where they don't have enough people to do the two main tasks: help and sign off.

Current remedial process is just "Write your name on the whiteboard and we'll come over to you when you're at the top of the queue". However that isn't the best approach (or the most over-engineered solution which Software Engineers are known for) to solving the issue, so DTK was born.

Installation
------------

DTK is written in coffeescript and runs on node, so there are numerous dependancies which are needed to get running. However, with the delight (and maybe disgust) of `bower` and `npm` we can handle a lot from now:

    npm install grunt-cli coffee
    bower install
    npm install
    grunt coffee
  
To run in development mode:

    grunt

To compile coffee down to JS:

    grunt coffee
  

Contribution
------------

Demonstrators et al: you're more than welcome to put in a PR for fixing issues or adding functionality - however there is no exact roadmap at the moment and it is in a state of flux so please hold on while I knock out some of the issues 

License
-------

DTK is licensed under the MIT

