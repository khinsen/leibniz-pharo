running
setUp
   sortGraph1 := LeibnizSortGraph new.
	sortGraph1 add: #A;
              add: #B;
              add: #C;
              add: #D;
				  make: #A subsortOf: #B;
				  make: #B subsortOf: #C;
				  make: #A subsortOf: #D.
	sortGraph2 := LeibnizSortGraph new.
	sortGraph2 add: #A;
				  add: #X;
				  add: #Y;
				  make: #A subsortOf: #X;
				  make: #X subsortOf: #Y.
	sortGraph3 := sortGraph1 copy.
	sortGraph3 add: #V;
				  add: #W;
				  make: #V subsortOf: #W.
