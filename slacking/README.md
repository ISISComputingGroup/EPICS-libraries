Slacking - Lazy modern C++ people also loves Slack !
====================================================

[![Build Status](https://travis-ci.org/coin-au-carre/slacking.svg?branch=master)](https://travis-ci.org/coin-au-carre/slacking)

Simple C++ Slack API
--------------------

*Slacking* is a lightweight **C++11 header only library** for communicating with the [Slack Web API](https://api.slack.com/web).  
It aims to be easy to use and stick to the API style proposed by Slack. *Slacking* requires to have an [API token](https://api.slack.com/docs/oauth-test-tokens).


Requirements
------------

+ C++11 compatible compiler. Tested with Clang (3.5, 3.6, 3.7) and GCC (4.9, 5).
+ [Curl](https://curl.haxx.se/libcurl/) (which you probably already have).

Note: *Slacking* uses the awesome [C++ Requests](https://github.com/whoshuu/cpr) (CPR) and [Nlohmann Json](https://github.com/nlohmann/json) which are already included in the project.
CPR has been rewritten to be a header only library. Hence, you don't have to install anything!


Installation
------------

Just copy the `include/slacking` folder in your project and add `#include "slacking.hpp"`. That's all.  
If you have already installed CPR or Nlohmann Json, feel free to use them accordingly to your project and just copy the `include/slacking.hpp` file.




Requirements
------------

+ C++11 compatible compiler. Tested with Clang (3.5, 3.6, 3.7) and GCC (4.9, 5).
+ [Curl](https://curl.haxx.se/libcurl/) (which you probably already have).

Note: *Slacking* uses the awesome [C++ Requests](https://github.com/whoshuu/cpr) (CPR) and [Nlohmann Json](https://github.com/nlohmann/json) which are already included in the project.
CPR has been rewritten to be a header only library. Hence, you don't have to install anything!


Installation
------------

Just copy the `include/slacking` folder in your project and add `#include "slacking.hpp"`. That's all.  


Example usage
-------------

#### Initialize a slack instance
```c++
auto& slack = slack::create("xxx-xxx-xxx-xxx"); // "xxx-xxx-xxx-xxx" is your Slack API token
slack.chat.channel = "#general"; // set a default channel
```

#### Sending a message in Slack is easy ([preview](https://goo.gl/GC9w3p))

```c++
slack.chat.postMessage("Hello there!"); // will send the message "Hello there!" in the channel #general with the registered token
```
Note that we try to stick with the Slack API documentation: the __chat.postMessage__ syntax is easily recognizable.

#### Sending a message with a specified channel, username and icon ([preview](https://goo.gl/1UhzpM))

```c++
slack.chat.channel_username_iconemoji("#superchannel", "Ghost Bot", ":ghost:");
slack.chat.postMessage("Slacking is simple"); // will send the message "Hello there!" in the channel #general with the registered token
```
Note that theses changes are persistent inside the slack instance. 

#### Sending complex messages (functionnal approach) ([preview](https://goo.gl/GLrlT2))

If you need maximum control, you can use the generic functions `slack::post` or `slack::get`.  
Everything available in [Web Slack API](https://api.slack.com/methods) is possible from here.
```c++
slack::post (   
                "chat.postMessage",
                {
                    {"text"      , "Slacking is awesome!" },
                    {"channel"   , "#mychannel"           },
                    {"username"  , "peach"                },
                    {"icon_emoji", ":princess:"           }
                } // note that "token" is not needed here and is a "registered" parameter
            ); // it is automatically inserted when using slack::post()
```


#### Sending complex messages (JSON approach) ([preview](https://goo.gl/GLrlT2))

If you prefer to mimic the Json approach given in the API, you can also use this syntax: 
```c++
 auto json = R"({
    "text": "But Our Princess is in Another Castle!",
    "channel" : "#general",
    "username": "peach",
    "icon_emoji": ":princess:"
})"_json;

slack::post("chat.postMessage", json);
```

Check out the [examples](examples/) for more illustrations.  


A more elaborated example ([preview](https://goo.gl/syHOka))
-------------------------

You can make richly-formated messages with [attachments](https://api.slack.com/docs/attachments).

```c++
slack.chat.channel_username_iconemoji("#ticker-channel", "Support Bot", ":hamster:");

auto json_attachments = R"([
    {
        "fallback": "New ticket from Bjarne Stroustrup - Ticket #2017: Still looking for reflection",
        "pretext": "New ticket from Bjarne Stroustrup",
        "title": "Ticket #2017: Still looking for reflection",
        "title_link": "https://www.youtube.com/watch?v=ND-TuW0KIgg",
        "text": "Help me adding reflection!",
        "color": "#7CD197",
        "image_url": "https://img.youtube.com/vi/ND-TuW0KIgg/2.jpg"
    }
])"_json;

slack.chat.attachments = json_attachments;
auto response = slack.chat.postMessage(); // get a slack::Json object
std::cout << response << std::endl;
```

[![Slacking attachments](doc/showcase_attachments.png?raw=true "Slacking attachments")](https://www.youtube.com/watch?v=ND-TuW0KIgg)

The output is a JSON response sent back by Slack:
```
{"channel":"C1AUF9AN4","message":{"attachments":[{"color":"7CD197","fallback":"New ticket from Bjarne Stroustrup - Ticket #2017: Still looking for reflection","id":1,"image_bytes":4820,"image_height":90,"image_url":"https://img.youtube.com/vi/ND-TuW0KIgg/2.jpg","image_width":120,"pretext":"New ticket from Bjarne Stroustrup","text":"Help me adding reflection!","title":"Ticket #2017: Still looking for reflection","title_link":"https://www.youtube.com/watch?v=ND-TuW0KIgg"}],"bot_id":"B20LJ4Y12","icons":{"emoji":":hamster:","image_64":"https://slack.global.ssl.fastly.net/d4bf/img/emoji_2015_2/apple/1f439.png"},"subtype":"bot_message","text":" ","ts":"1464251666.000063","type":"message","username":"Support Bot"},"ok":true,"ts":"1464251666.000063"}
```

Since Slack::Json is a [nlohmann::json](https://github.com/nlohmann/json), you have all the features of the latter one (conversions, STL like access, ...). For instance, `response["ok"]` will give `true`.


#### A word about error handling

Slacking will throw a runtime error exception if the curl request does not succeed, if the response from Slack is not correct, or if `response["ok"]` received is not `true`. You are free to handle these exceptions the way you like.


Ongoing work
------------

The library on `master` branch should always be functional.
You can use the `slack::post` or `slack::get` methods to fully exploit the [Slack Web API methods](https://api.slack.com/methods). You can refer to [examples/06-custom_post_get.cpp.cpp](examples/06-custom_post_get.cpp.cpp).

Following C++ helpers free functions and member methods are available in *Slacking* for convenience :

+ [api.test](https://api.slack.com/methods/api.test) (see [examples/01-basic.cpp](examples/01-basic.cpp))
+ [chat.postMessage](https://api.slack.com/methods/chat.postMessage) (see [examples/00-showcase.cpp](examples/00-showcase.cpp), [examples/01-basic.cpp](examples/01-basic.cpp), [examples/02-basic.cpp](examples/02-basic.cpp), [examples/03-attachments.cpp](examples/03-attachments.cpp))
+ [users.list](https://api.slack.com/methods/users.list), [users.info](https://api.slack.com/methods/users.info) (see [examples/04-users.cpp](examples/04-users.cpp))
+ [channels.list](https://api.slack.com/methods/users.list), [channels.info](https://api.slack.com/methods/channels.info) (see [examples/05-channels.cpp](examples/05-channels.cpp))

Try out the "magic" functions for grabbing ready-to-use structures.
This is an ongoing work so more convenient helpers functions and structures might come in the near future...  
If you need any features feel free to ask and contribute.


Manage Slacking instance
------------------------

Here are two approaches to keep alive the *Slacking* session in your program so you can use it anytime, anywhere.

####Use Meyers singleton

*Slacking* provides free convenient functions : `slack::create(const std::string& token)` and `slack::instance()`.
Initialize the Slacking instance with:
```c++
auto slack& = slack::create("xxx-xxx-xxx-xxx");
```
And when you are in another scope and you have lost the `slack` reference, you can grab it again with :  
```c++
auto slack& = slack::instance();
```
It might not be the recommended way but since we generally want to handle only one Slack instance (one token), it is highly convenient. You can refer to the example usage and  [examples/01-basic.cpp](examples/01-basic.cpp).

####Pass by reference (or by pointer)

An other approach is to pass the *Slacking* instance by reference, store it, and call the appropriate methods when needed.

```c++
void foo(slack::Slacking& slack) {
    slack.chat.postMessage("I am slacking!", "#random");
}

int main() {
    slack::Slacking slack_instance{"xxx-xxx-xxx-xxx"};
    foo(slack_instance);
}
```

You can use a [std::reference_wrapper](http://en.cppreference.com/w/cpp/utility/functional/reference_wrapper) as shown in [examples/02-basic.cpp](examples/02-basic.cpp). This strategy is useful if you have to manage several Slacking instances.

### Build the examples

```
mkdir build && cd build
cmake .. && make
examples/[whatever]
```

In your project, if you want a verbose output like when running the examples, add the following compilation flag:  
`-DSLACKING_VERBOSE_OUTPUT=1`.
