//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;
contract bookstore{
    address public owner;
    struct book{
        string title;
        string author;
        uint256 price;
        uint256 stock;
        bool isavailable;
    }
    mapping (uint256 => book) public books;
    uint256[] public bookIDs;
    uint256 public totalbooksSold;

    event bookadded(uint256 indexed  bookIDs, string title, string author,uint256 price, uint256 stock);
    event bookpurchased(uint256 indexed bookIDs, address indexed  buyer, uint256 quantity);
    event getownerbalance(address indexed owner, uint256 balance);
    event bookremoved(uint256 indexed bookIDs, string title, string author, uint256 price, uint256 stock);
    constructor () {
        owner = msg.sender;
    }
    function addbook(uint256 _bookIDs, string memory _title, string memory _author, uint256 _price, uint256 _stock) public{
      require (books[_bookIDs].price == 0, "Book already exists with this bookID!");
      books[_bookIDs] = book ({
        title: _title,
        author: _author,
        price: _price,
        stock: _stock,
        isavailable: _stock > 0
      });
      bookIDs.push(_bookIDs);
      emit bookadded(_bookIDs, _title, _author, _price, _stock);
    }
    function getbook(uint256 _bookIDs) public view returns (string memory, string memory, uint256, uint256, bool) {
        book memory Book =  books[_bookIDs];
        return(Book.title, Book.author, Book.price, Book.stock, Book.isavailable);
    }
    function buybook(uint256 _bookIDs, uint256 _quantity, uint256 _amount) public payable {
        book storage Book = books[_bookIDs];
        require(Book.isavailable, "This book is not available");
        require(Book.stock >= _quantity, "Not enough stock available!");
        require(_amount == Book.price * _quantity, "Incorrect Ether send!");

      Book.stock -= _quantity; 
      if (Book.stock == 0) {
        Book.isavailable = false;
      }
     payable(owner).transfer(msg.value);
     totalbooksSold += _quantity;
      emit bookpurchased(_bookIDs, msg.sender, _quantity);
    }
    function getallbooks() public view returns (uint256 [] memory, string [] memory, string [] memory, uint256 [] memory, uint256 [] memory) {
     uint256 length = bookIDs.length;
     string[] memory titles = new string[](length);
     string[] memory authors = new string[](length);
     uint256[] memory prices = new uint256[](length);
     uint256[] memory stocks = new uint256[](length);
     //populate arrays with book details
     for (uint256 i = 0; i < length; i++) {
      uint256 bookID = bookIDs[i];
      book memory b = books[bookID];
      titles[i] = b.title;
      authors[i] = b.author;
      prices[i] = b.price;
      stocks[i] = b.stock;
     }
     return (bookIDs, titles, authors, prices, stocks);
    }
    function removebook(uint256 _bookIDs) public {
      require(msg.sender == owner, "Only owner can remove books!");
      //check if book exists
      require(books[_bookIDs].price != 0, "Book does not exist!");
      emit bookremoved(
      _bookIDs, 
      books[_bookIDs].title, 
      books[_bookIDs].author,
      books[_bookIDs].price,
      books[_bookIDs].stock
      );
    //remove the book
    delete books[_bookIDs];
    for (uint256 i = 0; i < bookIDs.length; i++) {
      if (bookIDs[i] == _bookIDs) {
        bookIDs[i] = bookIDs[bookIDs.length - 1]; //replace with last element
        bookIDs.pop(); //remove last element
        break;
      }
    }
    }
    function removeAllbooks() public {
      require(msg.sender == owner,"Only owner can remove all books!");
      for (uint256 i = 0; i < bookIDs.length; i++) {
        uint256 bookID = bookIDs[i];
        emit bookremoved(bookID,
        books[bookID].title,
        books[bookID].author,
        books[bookID].price,
        books[bookID].stock
        );
        delete books[bookID];
      }
      delete bookIDs;
    }
    function gettotalbooksSold() public view returns (uint256) {
return totalbooksSold;
    }
     function ownerbalance() public view returns (uint256) {
      return address(owner).balance;
    }
}