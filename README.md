# Processing to Unity
Render Processing Sketches Screens as an Unity Texture2D (compatible with Windows, OSX and Linux)

## Example
<a href="http://www.youtube.com/watch?feature=player_embedded&v=WHieBDCzoCw
" target="_blank"><img src="http://img.youtube.com/vi/WHieBDCzoCw/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="560" height="315" border="10" /></a>




## Get Started
Download the files from the github repository:
### Unity
  - Add the file **ProcessingToTexture.cs** to your *Assets* folder. 
  - Create (or import) any  3D object, for example, a quad (GameObject > 3D Object > Quad)
  - Drag and drop the **ProcessingToTexture.cs** to the gameObject
  - Set the **width** and **height** based on the width and height from processing skecth
  - If you want run interactions on the processing sketchs, enable Unity to run on background (File > Build Settings > Player Settings... > *check* Run On Bakground)
  
### Processing
## Data Transference
This simple system sends multiple chunks of byte arrays from processing to Unity, using by default the localhost ip "127.0.0.1" at port "8051".



![img-title](top-image.png)



# Tables
| Tables        | Are           | Cool  |
| ------------- |---------------| -----|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |


# Basic Example (Processing)
```java
ScreenBroadcast sb;

void setup() {
  sb = new ScreenBroadcast();
  size(800, 800);
}

void draw() {
  //Draw things here!

  sb.BroadcastSplit(get());
  //Add some delay, change to higher values to have higher
  delay(20);
  //Anything bellow this line will be not send to Unity
}
```

# Basic Example (Unity)
![Unity example](https://github.com/lucascassiano/Processing-to-Unity/blob/master/example_unity.png "Image example")
