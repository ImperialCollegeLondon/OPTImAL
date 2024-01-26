run("Duplicate...", "title=firstselection duplicate");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Duplicate...", "title=sinogram_duplicate");
run("Combine...", "stack1=[Reslice of firstselection] stack2=sinogram_duplicate combine");
selectWindow("firstselection");
close();