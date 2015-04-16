# Ailurus #

This is a client gem to help people work programmatically with
[PANDA](http://pandaproject.net/) instances.

## Installation ##

    $ gem install ailurus

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
    >> dataset.search("A", :max_results => 1)
    => [["A", "1"]]

For datasets with indexed fields, you can perform additional searches and sorts
(better syntax TK):

    >> dataset = client.dataset("SLUG")
    >> dataset.create([{:name => "name", :index => true}])
    >> dataset.update([{"data" => ["alfa"]}, {"data" => ["bravo"]}, {"data" => ["charlie"]}])
    >> indexed_column_name = dataset.get_indexed_name("name")
    => "column_unicode_name"
    >> dataset.search("column_unicode_name:bravo")
    => [["bravo"]]
    >> dataset.search("*", :options => {"sort" => "column_unicode_name desc"})
    => [["charlie"], ["bravo"], ["alfa"]]

If you want to make an API request that hasn't been implemented yet in the
client, there's a potentially useful helper function you're welcome to use:

*   [Request a row by external ID](http://panda.readthedocs.org/en/1.1.1/api.html#id27)

        >> client.make_request("/api/1.0/dataset/counties/data/29019/")

*   [Update a row by external ID](http://panda.readthedocs.org/en/1.1.1/api.html#create-and-update)

        >> client.make_request("/api/1.0/dataset/counties/data/29019/", :method => :put, :body => {"data" => ["Boone County", "Missouri"]})

*   [Global search](http://panda.readthedocs.org/en/1.1.1/api.html#global-search)

        >> client.make_request("/api/1.0/data/", :query => {"q" => "pie"})

`Client#make_request` will handle adding your PANDA server's domain and
[required authentication options](http://panda.readthedocs.org/en/1.1.1/api.html#api-documentation),
so you don't have to repeat any of that stuff.

Also, it returns an
[OpenStruct](http://ruby-doc.org/stdlib-2.2.1/libdoc/ostruct/rdoc/OpenStruct.html),
so you don't have to include all those extra brackets and quotes:

    >> res = client.make_request("/api/1.0/dataset/counties/data/")
    >> res.name
    => "U.S. Counties"
    >> res.slug
    => "counties"

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
[red panda](http://en.wikipedia.org/wiki/Red_panda) =>
_Ailurus fulgens_ (scientific name) => Ailurus
