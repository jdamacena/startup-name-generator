import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'random_words.dart';

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.folder_special),
            tooltip: 'Open list of saved names',
            onPressed: _pushSaved,
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: divided.isNotEmpty
                ? new ListView(children: divided)
                : new Center(
              child: new Text("The awesome names you choose will be shown here"),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }

          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: GestureDetector(
        child: new Icon(
          alreadySaved ? Icons.star : Icons.star_border,
          color: alreadySaved ? Colors.yellow[900] : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      ),
      onTap: () => _pushDetails(pair),
    );
  }

  void _pushDetails(WordPair pair) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final bool alreadySaved = _saved.contains(pair);

          return new Scaffold(
            appBar: new AppBar(
              title: Text(pair.asPascalCase),
              actions: <Widget>[
                IconButton(
                  icon: new Icon(
                    alreadySaved ? Icons.star : Icons.star_border,
                    color: alreadySaved ? Colors.yellow[900] : null,
                  ),
                  onPressed: () {
                    setState(() {
                      if (alreadySaved) {
                        _saved.remove(pair);
                      } else {
                        _saved.add(pair);
                      }
                    });
                  },
                ),
                IconButton(
                    icon: new Icon(
                      Icons.share,
                    ),
                    onPressed: () => Share.share(
                        'I\'ve found a name for my startup, ${pair.asPascalCase}!'))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  new Text(
                    "Why this is a great name\n",
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.end,
                  ),
                  new Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porta pretium turpis, vel ultricies nunc placerat ut. Nullam vel nibh ac massa faucibus consequat. Pellentesque sit amet diam rutrum, aliquam orci vitae, laoreet turpis. Vestibulum et laoreet ligula, eu convallis dolor. Aenean ornare, ex nec fermentum interdum, lectus ex dictum sem, in facilisis ex lectus et orci. Nullam a sollicitudin risus, ut eleifend nibh. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sed scelerisque nunc, ac facilisis magna. Sed laoreet justo tellus, sit amet tempus velit condimentum ut. Aliquam ac placerat ex. Maecenas rutrum eleifend ipsum, nec faucibus dolor blandit id. Aliquam erat volutpat. Ut scelerisque id nisi eu pretium."),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}