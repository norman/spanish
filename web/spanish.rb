require "rubygems"
require "json"
require "haml"
require "sinatra"
require "spanish"

DICT = File.read(File.expand_path("../words.txt", __FILE__)).split("\n").freeze

before do
  @bag = params.to_a.flatten
  params.keys.each do |key|
    if params[:key].kind_of?(String)
      params[:key] = params[:key].force_encoding("UTF-8")
    end
  end
end

get "/" do
  haml :index
end

get "/ipa" do
  content_type 'text/html', :charset => 'utf-8'
  if params[:r]
    params[:words] = DICT[rand(DICT.length)]
  end
  @title = params[:words]
  @words = params[:words]
  @ipa = get_ipa(params[:words]).join(" &bull; ")
  haml :index
end

private

def get_ipa(words)
  options = %w[seseo voicing aspiration yeismo zheismo].select {|option| @bag.include? option}
  words.force_encoding("UTF-8")
  words.split(/\s+/u).map do |word|
    trans = Spanish.get_syllables(word, *options.map(&:to_sym))
    trans.map {|s| s.to_s }.join(" ")
  end
end

__END__

@@layout
!!! 5
%html
  %head
    %title= @title ||= "Spanish Phonology Library Demo"
    %script{:type => "text/javascript", :src => "http://code.jquery.com/jquery-1.4.2.min.js"}
    %script{:type => "text/javascript", :src => "/js.js"}
    %style{:type => "text/css"}
      :plain
        body {font-family: helvetica, sans-serif; font-size: 16px; background-color: #f0f0f0;}
        h1 {font-family: "Lucida Grande", sans-serif;}
        input {font-size: 22px;}
        #result {text-align: center; font-size: 40px; margin: 10px 0 10px 0; padding: 10px 0 10px 0;
          border: 1px #c0c0c0 solid; border-radius: 10px;}
        #wrapper {width: 600px; margin: 10px auto 20px auto; background-color: #fff; padding: 5px 40px 40px 40px;
          border: 1px solid #c0c0c0; border-radius: 10px;}
        #footer {width: 600px; margin: 10px auto 0 auto; text-align: right; font-size: 11px;}
  %body
    #wrapper
      = yield
    #footer
      <a href="http://github.com/norman/spanish">Source code</a>

@@index
%h1 Spanish Phonology Library Demo
%p
  This library proceses Spanish orthography into <a href="http://github.com/norman/phonology/blob/master/lib/phonology/features.rb">bundles
  of phonological featueres</a> represented using
  <a href="http://en.wikipedia.org/wiki/International_Phonetic_Alphabet">IPA</a>
  and makes use the sequence
  <a href="http://en.wikipedia.org/wiki/Sonority_Sequencing_Principle">Sonority Sequencing Principle</a>
  to perform syllabification. This allows it to represent
  Spanish text in any dialect, and accurately syllabifies without the use of
  regular expressions.
%p
  Enter a Spanish word to see it in
  You can also select phonological rules for various Spanish dialects.
- if @ipa
  #result= "#{@words}: #{@ipa}"
%form{:action => "/ipa", :method => "get"}
  .options
    %h3 Dialect Options
    %input{:type => "checkbox", :name => "seseo", :value => "1", :id => "seseo", :checked => @bag.include?("seseo")}
    %label{:for => "seseo"} Seseo - no disinction between "casar" and "cazar"
    %br
    %input{:type => "radio", :name => "y", :value => "yeismo", :id => "yeismo", :checked => @bag.include?("yeismo")}
    %label{:for => "yeismo"} Yeísmo - "calló" and "cayó" both like English "y"
    %br
    %input{:type => "radio", :name => "y", :value => "zheismo", :id => "zheismo", :checked => @bag.include?("zheismo")}
    %label{:for => "zheismo"} Zheísmo - "calló" and "cayó" both like English "a<strong>z</strong>ure"
    %br
    %input{:type => "radio", :name => "s", :value => "voicing", :id => "voicing", :checked => @bag.include?("voicing")}
    %label{:for => "voicing"} Voicing - "s" in "desden" pronounced like English "z".
    %br
    %input{:type => "radio", :name => "s", :value => "aspiration", :id => "aspiration", :checked => @bag.include?("aspiration")}
    %label{:for => "voicing"} Aspiration - "s" in "desden" pronounced like English "h".
  .phrase
    %h3 Word or phrase
    %input#words{:type => "text", :size => "40", :value => @words, :name => "words"}
    %input#submit{:type => "submit", :value => "See IPA"}
    %input#submit{:type => "submit", :name => "r", :value => "Random"}
    %span#indicator{:style => "display: none;"} ...
