run("Duplicate...", "duplicate");
run("Reslice [/]...", "output=1.000 start=Left avoid");
run("Duplicate...", " ");
run("Combine...", "stack1=[Reslice of Default-1] stack2=[Reslice of Default-1-1] combine");
