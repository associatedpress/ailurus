# Ailurus #

This is a client gem to help people work programmatically with
[PANDA](http://pandaproject.net/) instances.

## Usage ##

    >> require "ailurus"
    >> client = Ailurus::Client.new
    >> dataset = client.dataset("DATASET_SLUG")

    >> metadata = dataset.metadata
    >> metadata.slug
    => "DATASET_SLUG"

    >> results = dataset.search("search query")

    >> dataset = client.dataset("NEW_DATASET_SLUG")
    >> dataset.create([{:name => "letter", :type => "unicode"}, {:name => "number", :type => "int"}])
    >> dataset.update([{"data" => ["A", "1"]}, {"data" => ["A", "2"]}])
    >> dataset.search("A")
    => [["A", "1"], ["A", "2"]]

For datasets with indexed fields, you can perform additional searches and sorts
(better syntax TK):

    >> dataset = client.dataset("SLUG")
    >> dataset.create([{:name => "name", :index => true}])
    >> dataset.update([{"data" => ["alfa"]}, {"data" => ["bravo"]}, {"data" => ["charlie"]}])
    >> indexed_column_name = dataset.get_indexed_name("name")
    => "column_unicode_name"
    >> dataset.search("column_unicode_name:bravo")
    => [["bravo"]]
    >> dataset.search("*", {"sort" => "column_unicode_name desc"})
    => [["charlie"], ["bravo"], ["alfa"]]

## Configuration ##

To interact with a PANDA server, you'll need its domain (hostname), a user's
[API key](http://panda.readthedocs.org/en/1.1.1/api_keys.html) and that user's
email address.

You'll then need to get those to your `Ailurus::Client` instance somehow when
you initialize it.

You can pass them explicitly to the constructor:

    client = Ailurus::Client.new(
      :api_key => "api_key_goes_here",
      :domain => "panda.example.com",
      :email => "somebody@example.com")

If any of those options is omitted, Ailurus will look for it in the environment
variable `PANDA_API_KEY`, `PANDA_DOMAIN` or `PANDA_EMAIL`, as appropriate.

## Name ##

Ruby client for PANDA => `ruby-panda` =>
[red panda](http://en.wikipedia.org/wiki/Red_panda) => _Ailurus fulgens_ =>
Ailurus
