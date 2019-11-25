<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css" />
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap-theme.min.css" />
        <script src="https://code.jquery.com/jquery.js"></script>
        <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"></script>
        <script>
function setSelects() {
    document.forms[0].t.value = "[% type %]"; 
}
        </script>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-45771660-3', 'scrabblecheat.org.uk');
  ga('send', 'pageview');

</script>
    </head>
    <body onload="setSelects()">
        <div class="container">
            <h2>Scrabble Cheat</h2>
            <form class="form-horizontal" role="form">
                <div class="form-group">
                    <label class="col-md-1 control-label" for="type">Type</label>
                    <div class="col-md-3">
                        <select class="form-control" id="type" name="t" />
                            <option value="p">Permute</option>
                            <option value="r">Regex</option>
                            <option value="a">Anagram</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-1 control-label" for="word">Letters</label>
                    <div class="col-md-3">
                        <input type="text" class="form-control" name="w" id="word" placeholder="type letters here" value="[% word %]" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-default">Submit</button>
                    </div>
                </div>
            </form>
            [% IF words.size %]
            <table class="table">
                <tr><th>Word</th><th>Length</th><th>Value</th></tr>
                [% FOREACH word IN words %]
                    <tr><td><a href="http://en.wiktionary.org/wiki/[% word.w %]">[% word.w %]</a></td><td>[% word.l %]</td><td>[% word.v %]</td></tr>
                [% END %]
            </table>
            [% END %]
        </div>
    </body>
</html>
