# Processing to Unity
Send Processing Screen image to Unity using UDP connection.

## Example
<iframe width="560" height="315" src="https://www.youtube.com/embed/WHieBDCzoCw" frameborder="0" allowfullscreen></iframe>

## Get Started
Download the files from the github repository:
### Unity
  Add the file *ProcessingToTexture.cs* to your

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
```javascript
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
```javascript
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
