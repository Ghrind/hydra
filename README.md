# Hydra

Hydra is a terminal interface library written in crystal.

## Disclaimer

This is my first project in Crystal and my first interface library, so the code may go through various changes.

I would be very happy to have propositions on how to improve the code / the architecture of the library.

Also, I should write more test :shame:

## Installation

You'll need to install the dependencies using `shards install`

You'll also need the development libraries for libtermbox.

Example for Manjaro:

    yaourt -S termbox-git

## Example application

You can run [file_manager.cr](examples/file_manager.cr) in order to see the library in action.

    crystal run examples/file_manager.cr

## Features

There are various examples that showcase the different features.

### Application

Minimal setup is:

    app = Hydra::Application.setup # => Nothing happens for the user

    # Once the application is running, pressing ctrl-c will stop it.
    app.bind("keypress.ctrl-c", "application", "stop")

    # Define elements and events here

    app.run # => Screen is cleared and the application is displayed

    # The application will loop until ctrl-c is pressed

    app.teardown # => Reset the screen

### Elements

You can add elements and display them on the screen.

    app = Hydra::Application.setup
    app.add_element({
      :id => "my-text",
      :type => "text",
      :value => "Hello World",
    })

    el = Hydra::Element.new(...)
    app.add_element(el)

An element must have a unique id and a type, see bellow for available types.
The id is used by the events mechanism (see bellow).

Elements are visible by default and can be hidden:

    el = Hydra::Element.new(...) # => el is visible
    el = Hydra::Element.new({ :visible => "false", ...}) # => el is hidden

    el.show
    el.hide

Elements can be positioned:

    el = Hydra::Element.new({ :position => "3:7", ...}) # => el has an absolute position x = 3, y = 7

    el = Hydra::Element.new({ :position => "center", ...}) # => el is positioned at the bottom of the screen

See `Hydra::View#render_element` for the supported values for position.

Elements can then be moved:

    el = Hydra::Element.new({ :position => "3:7", ...}) # => el has an absolute position x = 3, y = 7
    el.move(4, 8) # => el is now at x = 4, y = 8

You can add custom elements to your application:

    class MyElement < Hydra::Element
      # Define new methods
      # Override Hydra::Element#trigger or any other method
    end

    app = Hydra::Application.setup
    el = MyElement.new(...)
    app.add_element(el)

#### Elements collection

There is a class to handle an elements collection: `ElementsCollection`, it provides utility methods.

### Events

[asynchronous.cr](examples/asynchronous.cr)

#### Keypresses

[keypress.cr](examples/keypress.cr)

### View

[moving_elements.cr](examples/moving_elements.cr)

### State

[state.cr](examples/state.cr)

### Colors / ExtendedString

[colors.cr](examples/colors.cr)

### Logging

```crystal
Log.setup do |c|
  backend = Log::IOBackend.new(File.open("./hydra.log", "w"))

  c.bind "hydra.*", :debug, backend
end
```

## Elements

#### Text

The text element is used to display single or multiline text.

#### Prompt

This is your &lt;input type="text"> element: it allows the user to enter a string.

[prompts.cr](examples/promps.cr)

#### List

A list of various elements, user can select one.

[list.cr](examples/list.cr)

#### LogBox

A box that display the latest messages it has received. Scroll included.

## Examples

* [asynchronous.cr](examples/asynchronous.cr)
* [colors.cr](examples/colors.cr)
* [file_manager.cr](examples/file_manager.cr)
* [keypress.cr](examples/keypress.cr)
* [list.cr](examples/list.cr)
* [moving_elements.cr](examples/moving_elements.cr)
* [prompts.cr](examples/promps.cr)
* [state.cr](examples/state.cr)
* [websocket_application.cr](examples/websocket_application)
* [websocket_client.cr](examples/websocket_client)

## Contributing

1. Fork it (https://github.com/Ghrind/hydra/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

Contributors

* Ghrind - Benoît Dinocourt - creator, maintainer
