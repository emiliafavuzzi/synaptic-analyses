//Start by creating an Input folder on your desktop (or wherever you prefer)
//Place the images to analyze in that Input folder
//Create an Output folder where the intermediate images will be saved
//Replace the path /Users/efavuzzi/Desktop/output for yours
//Replace the path /Users/efavuzzi/Desktop/input for yours

input = getDirectory("Input directory");
output = getDirectory("Output directory");

Dialog.create("File type");
Dialog.addString("File suffix: ", ".tif", 5);
Dialog.show();
suffix = Dialog.getString();

processFolder(input);
setBatchMode(true);
function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	};
};
function processFile(input, output, file) {
	open(input + file);
//Start script and save the image you are working on (it will be overwritten every time)
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/picture-1.tif");
run("Duplicate...", "title=PV.tif duplicate channels=4");
selectWindow("PV.tif");
run("Despeckle");
run("Smooth");
run("Enhance Contrast...", "saturated=0.5");
run("RGB Color");
run("Color Threshold...");
//Run the threshold detection
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=0;
max[0]=255;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
//this min[2]=20 is what you need to modify to change the threshold
min[2]=20;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
//detect cell body
//setTool("polygon") find ROI;
setOption("BlackBackground", false);
run("Make Binary");
run("Analyze Particles...", "size=10-Infinity show=Masks");
run("Create Selection");
run("Enlarge...", "enlarge=-2.5");
run("Enlarge...", "enlarge=3");
waitForUser("CHECK ROI");
//this can be removed for a fully antomated script
//if ROI is not ok just do a manual selection and click ok - in 99% of the cases the selection is ok
run("Fill");
run("Clear Outside");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/PVcell.tif");
close("\\Others");
open("/Users/efavuzzi/Desktop/output/PVcell.tif");
run("Select None");
run("Invert");
run("Make Binary");
run("Analyze Particles...", "size=10-Infinity show=Masks summarize");
// PV end
// Synapsin detection
open("/Users/efavuzzi/Desktop/output/picture-1.tif");
selectWindow("picture-1.tif");
run("Duplicate...", "title=synapsin.tif duplicate channels=2");
selectWindow("synapsin.tif");
run("Despeckle");
run("Smooth");
run("Enhance Contrast...", "saturated=0.5");
run("RGB Color");
run("Color Threshold...");
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=0;
max[0]=255;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
//the following line can be modified for threshold detection
min[2]=115;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
run("Watershed");
run("Analyze Particles...", "size=0.10-infinity circularity=0.00-1.00 show=Masks");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/presynaptic.tif");
close("\\Others");
// Synapsin end
// Gephyrin starts
open("/Users/efavuzzi/Desktop/output/picture-1.tif");
run("Duplicate...", "title=geph.tif duplicate channels=1");
selectWindow("geph.tif");
run("Despeckle");
run("Smooth");
run("RGB Color");
run("Color Threshold...");
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=0;
max[0]=255;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
min[2]=70;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
run("Watershed");
run("Analyze Particles...", "size=0.10-infinity circularity=0.00-1.00 show=Masks");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/gephyrin.tif");
close("\\Others");
// Gephyrin end
// Homer starts
open("/Users/efavuzzi/Desktop/output/picture-1.tif");
run("Duplicate...", "title=homer.tif duplicate channels=3");
selectWindow("homer.tif");
run("Despeckle");
run("Smooth");
run("RGB Color");
run("Color Threshold...");
min=newArray(3);
max=newArray(3);
filter=newArray(3);
a=getTitle();
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=0;
max[0]=255;
filter[0]="pass";
min[1]=0;
max[1]=255;
filter[1]="pass";
min[2]=70;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
rename(a);
run("Watershed");
run("Analyze Particles...", "size=0.10-infinity circularity=0.00-1.00 show=Masks");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/homer1.tif");
close("\\Others");
// Homer end
//create pre+post inhibitory
open("/Users/efavuzzi/Desktop/output/gephyrin.tif");
open("/Users/efavuzzi/Desktop/output/presynaptic.tif");
run("Merge Channels...", "c1=gephyrin.tif c2=presynaptic.tif create");
run("Stack to RGB");
run("8-bit");
// a line can be added here to save composite
run("Invert");
setThreshold(130, 255);
run("Convert to Mask");
run("Analyze Particles...", "size=0.1-Infinity");
run("Invert");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/prepost_I.tif");
//create pre+post excitatory
open("/Users/efavuzzi/Desktop/output/homer1.tif");
open("/Users/efavuzzi/Desktop/output/presynaptic.tif");
run("Merge Channels...", "c1=homer1.tif c2=presynaptic.tif create");
run("Stack to RGB");
run("8-bit");
// a line can be added here to save composite
run("Invert");
setThreshold(130, 255);
run("Convert to Mask");
run("Analyze Particles...", "size=0.1-Infinity");
run("Invert");
saveAs("Tiff", "/Users/efavuzzi/Desktop/output/prepost_E.tif");
run("Close All");
// coloc the pre+post inhib w/ somata
open("/Users/efavuzzi/Desktop/output/PVcell.tif");
run("Select None");
run("Invert");
open("/Users/efavuzzi/Desktop/output/prepost_I.tif");
run("Merge Channels...", "c2=PVcell.tif c1=prepost_I.tif create");
run("Stack to RGB");
run("8-bit");
//run("Threshold...");
setThreshold(120, 255);
run("Convert to Mask");
run("Analyze Particles...", "size=0.1-Infinity show=Masks");
rename("inhibitory synapses");
run("Analyze Particles...", "size=0.00-Infinity summarize");
run("Close All");
// coloc the pre+post exc w/ somata
open("/Users/efavuzzi/Desktop/output/PVcell.tif");
run("Select None");
run("Invert");
open("/Users/efavuzzi/Desktop/output/prepost_E.tif");
run("Merge Channels...", "c2=PVcell.tif c1=prepost_E.tif create");
run("Stack to RGB");
run("8-bit");
//run("Threshold...");
setThreshold(120, 255);
run("Convert to Mask");
run("Analyze Particles...", "size=0.1-Infinity show=Masks");
rename("excitatory synapses");
run("Analyze Particles...", "size=0.00-Infinity summarize");
run("Close All");
	print("Processing: " + input + file);
	print("Inhibitory");
	print("Excitatory");
}
setBatchMode(false);
print("BATCH COMPLETED!");