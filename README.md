# CLI Ruby Chess Game

This is the final project in the Ruby curriculum at [The Odin Project](https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project?ref=lnav).

## Demo
<img src="demo/chess_demo.gif" alt="short chess game" width=auto height="400px"/><br>
*1-minute demo game featuring [Owen's Defense](https://en.wikipedia.org/wiki/Owen%27s_Defence) opening moves*

## Use of Design Patterns
Right after I started working on this project, I joined a book club reading [Design Patterns in Ruby](https://www.amazon.com/Design-Patterns-Ruby-Russ-Olsen/dp/0321490452). When we are done reading and discussing all of the design patterns, I hope to come back to this project to review and refactor. Currently, we've studied six patterns and I have identified two that are useful in this application.

**[Strategy](https://sourcemaking.com/design_patterns/strategy):** 
I implemented this pattern using the `Board` class as the context and the four `Movement` classes as different strategies. The `Board` changes its movement strategy to update the position of the piece(s) based on if the move is a basic move, en passant move, castling move, or pawn promotion move. 

**[Observer](https://sourcemaking.com/design_patterns/observer):** 
I implemented this pattern using the `Board` class as the subject and the `Piece` classes as the observers. When an instance of `Piece` is created, it becomes an observer of the `Board` instance. Every time a `Piece` moves in the `Board`, all of the pieces update their legal moves and captures. In addition, when a `Piece` is removed from the `Board`, that observer must also be removed.

## Project Requirements
**2-Player Game with Legal Moves:** 
I wanted to create a similar UI as [chess.com](chess.com) to visually display the opponent's previous piece, the active piece, and the legal moves/captures. Therefore, I needed to divide each turn into two different parts.

**Save and Load Games:** 
Players can save (or quit) a game at the beginning of every turn. Before a game starts, players have the choice to play a new game or load a saved game.

**Tests:** 
I wrote unit tests for incoming command methods, incoming query methods, and outgoing command methods. Most of the time, I wrote tests and the method in tandem. Occasionally, I used TDD when I wanted the test to guide the results. For example, I used TDD as I developed the methods that determined each piece's moves and captures.

**Simple Computer Player (Optional):** 
Since the white player always goes first and has a slightly higher advantage, I decided to have the computer player always be black to keep the game set-up simple. The computer player selects a piece with legal moves and/or captures.

## How to Play
This chess game will look slightly different on other command line interfaces (CLI), such as repl.it or your computer. Not only will the colors vary, but the font size of my CLI is 24 points to increase the size of the unicode chess pieces.

### Play Online
If you want to play this chess game without installing it on your computer, you can play it [online](https://repl.it/@rlmoser/rubychess#README.md). Just click the `run` button at the top of the page. It will take a few seconds to load the dependencies and then the game menu will appear.

### Prerequisites
- ruby >= 2.6.5
- bundler >= 2.1.4

### Installation
- Clone this repo ([instructions](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository))
- Navigate into this project's directory `cd ruby_chess`
- Run `bundle install`

### To Play
- Run `ruby lib/main.rb` 
- Play a 1-player or 2-player game (can save a game to load at a later time)

## Running the tests
- To run the entire test suite, run `rspec`
- To run the tests for one file in the spec folder, run `rspec spec/file_name.rb` 
- To run the tests for one file in the pieces folder, run `rspec spec/pieces/file_name.rb` 
- To run the tests for one file in the movement folder, run `rspec spec/movement/file_name.rb` 
