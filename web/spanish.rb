require "rubygems"
require "json"
require "haml"
require "sinatra"
require "spanish"

before do
  params.keys.each do |key|
    if params[:key].kind_of?(String)
      params[:key] = params[:key].force_encoding("UTF-8")
    end
  end
end

get "/" do
  haml :index
end

get "/ipa/:words" do
  content_type 'text/html', :charset => 'utf-8'
  @title = params[:words]
  @ipa = get_ipa(params[:words]).join(" &bull; ")
  haml :index
end

get "/ipa" do
  redirect "/ipa/#{params[:words]}"
end

get "/api/ipa/:words" do
  content_type 'application/json', :charset => 'utf-8'
  get_ipa(params[:words]).to_json
end

private

def get_ipa(words)
  words = words.force_encoding "UTF-8"
  words.split(/\s+/u).map {|word| Spanish::Syllable.syllabify(word).map {|s| s.to_s }.join(" ")}
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
        #result {font-size: 60px}
        #wrapper {width: 600px; margin: 10px auto 0 auto; background-color: #fff; padding: 5px 40px 40px 40px;
          border: 1px solid #c0c0c0; border-radius: 10px;}
    :javascript
      jQuery(function() {
        $("html").ajaxStart(function() {
          $('#indicator').show();
        });
        $("html").ajaxStop(function() {
          $('#indicator').hide();
        });
        $('#submit').click(function(event) {
          event.preventDefault();
          try {
            var words = $('#words').val();
            $.getJSON('/api/ipa/' + encodeURI(words), function(data) {
              $('#result').html(data.join(" &bull; "));
            });
          }
          catch(error) {
            alert(error);
          }
        });
      });
  %body
    #wrapper
      = yield

@@index
%h1 Spanish Phonology Library Demo
%p
  This library can read Spanish orthography and return a
  representation in
  <a href="http://en.wikipedia.org/wiki/International_Phonetic_Alphabet">IPA</a>,
  including sylabification and stress.
  To see it in action, enter a word or phrase
  below.
%form{:action => "/ipa", :method => "get"}
  %p
    %input#words{:type => "text", :size => "40", :value => @ipa, :name => "words"}
    %input#submit{:type => "submit", :value => "See IPA"}
    %span#indicator{:style => "display: none;"} ...
#result= @ipa
