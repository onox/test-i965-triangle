
var svgFontMapper = func(family, weight){
		#print(sprintf("Canvas font-mapper %s %s",family,weight));
		if (family =="Liberation Mono"){
			if (weight == "bold"){
				return "LiberationFonts/LiberationMono-Bold.ttf";
			}elsif(weight == "normal"){
				return "LiberationFonts/LiberationMono-Regular.ttf";
			}
		}elsif(family =="Liberation Sans"){
			if (weight == "bold"){
				return "LiberationFonts/LiberationSans-Bold.ttf";
			}elsif(weight == "normal"){
				return "LiberationFonts/LiberationSans-Regular.ttf";
			}
		}else{
			return "LiberationFonts/LiberationMono-Regular.ttf";
		}
};


var PageClass = {
	new : func(id,group){
		var m = { parents: [PageClass] };
		m._id = id;
		m._group = group.setVisible(0);
		m._can = {
			pageNumber : m._group.createChild("text","PageNumber")
						.setFont("LiberationFonts/LiberationMono-Bold.ttf")
						.setColor(0,0,0)
						.setFontSize(30, 1)
						.setAlignment("right-bottom")
						.setTranslation(760, 1016)
						.setText("x of x"),
		};
		m._number = 0;
		return m;
	},
	loadSVG : func(file){
		canvas.parsesvg(
			me._group, 				# the group to parse into
			file,					# the svg file
			{"font-mapper": svgFontMapper}		# the font mapper to map the fonts SVG -> FG
		);
		
	},
	setVisible : func(value){
		if(me._group!=nil){
			me._group.setVisible(value);
		}
	},
	setPageNumber : func(number,count = 0){
		me._number = number;
		if(count > 0){
			me._can.pageNumber.setText(sprintf("%i of %i",me._number,count));
		}else{
			me._can.pageNumber.setText(sprintf("%i",me._number));
		}
	}
};

var canvasBook = {
	new: func()
	{
		debug.dump("Creating new canvasBook...");

		var m = { parents: [canvasBook] };
		
		# create a new canvas...
		m.canvas = canvas.new({
			"name": "Book",
			"size": [1024, 1024],
			"view": [1024, 1024],
			"mipmapping": 1
		});
		# find the place for the texture
		m.canvas.addPlacement({"node": "Book-Screen"});
		m.canvas.setColorBackground(1,1,1);
   
		m._pages = [];
		m._pageIndex = nil;
		m._pageCount = 0;
		m._activePageIndex = 0;

		return m;
	},
	loadBook : func(book){
		me._pageIndex = book;
		me._pageCount = size(book);
		var counter = 1 ;
		foreach (var page; book){
			
			var p = PageClass.new(page.id,me.canvas.createGroup(page.id));
			p.loadSVG(page.file);
			p.setPageNumber(counter,me._pageCount);
			
			append(me._pages,p);
			
			counter+= 1;
		}
	},
	gotoPage : func(index){
		
		me._pages[me._activePageIndex].setVisible(0);
		me._activePageIndex = index;
		me._pages[me._activePageIndex].setVisible(1);
	},
	scroll : func(amount){
		
		me._pages[me._activePageIndex].setVisible(0);
		
		me._activePageIndex += amount;
		
		if(me._activePageIndex >= me._pageCount){ me._activePageIndex = me._pageCount-1; }
		if(me._activePageIndex < 0){ me._activePageIndex = 0 }
		
		me._pages[me._activePageIndex].setVisible(1);
		
	}
};


##### Building instances ###########

var manual = canvasBook.new();

var BOOK_DE = [	
	{
		id		: "Page_01",
		file		: "Aircraft/707/Models/Cockpit/Book/DE/Page_01.svg",
	},
	{
		id		: "Page_02",
		file		: "Aircraft/707/Models/Cockpit/Book/DE/Page_02.svg",
	},
	{
		id		: "Page_03",
		file		: "Aircraft/707/Models/Cockpit/Book/DE/Page_03.svg",
	}
];

manual.loadBook(BOOK_DE);
manual.gotoPage(0);

# setlistener("/nasal/canvas/loaded", func {
#   manual = canvasBook.new();
#   manual.loadBook(BOOK_DE);
#   manual.gotoPage(1);
# }, 1);
