/* ----------------
 ScreenBroadcast
 reference: https://forum.processing.org/two/discussion/17921/raspberry-pi-acting-as-a-syphon-server/p1
 version 1.0.3
 */

/*--------------------------------------
 * ScreenBroadcast
 * version: 1.0.3
 * compatible with [unity] ProcessingToTexture v1.0
 * Creation date: September 2016;
 * 
 * This code gets all the pixels from the screen, encodes the image to JPG and sends the byte array as 
 * multiples chunks of data on an UDP connection ( @ port 8051)
 * Tutorial at:
 * https://github.com/lucascassiano/Processing-to-Unity
 * 
 * >Sends data at:
 * localhost : 8051
 --------------------------------------*/

import javax.imageio.*;
import java.awt.image.*;
import java.io.*;
import java.net.*;
import java.util.*;

public class ScreenBroadcast {
  private DatagramSocket ds;
  //Config for Unity Connection
  private int unityPort = 8051; //if you change it here, remember to also change on the Unity Code
  private String unityIP = "localhost";

  public ScreenBroadcast() {
    try {
      ds = new DatagramSocket();
      ds.setSendBufferSize(1000000);
    } 
    catch (SocketException e) {
      e.printStackTrace();
    }
  }

  public ScreenBroadcast(String ip, int port) {
    unityIP = ip;
    unityPort = port;
    try {
      ds = new DatagramSocket();
      ds.setSendBufferSize(1000000);
    } 
    catch (SocketException e) {
      e.printStackTrace();
    }
  }

  /*Broadcast Splitted data (split by 4)*/
  public void BroadcastSplit(PImage img) {
    // We need a buffered image to do the JPG encoding
    BufferedImage bimg = new BufferedImage( img.width, img.height, BufferedImage.TYPE_INT_RGB );

    // Transfer pixels from localFrame to the BufferedImage
    img.loadPixels();
    bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

    // Need these output streams to get image as bytes for UDP communication
    ByteArrayOutputStream baStream    = new ByteArrayOutputStream();
    BufferedOutputStream bos      = new BufferedOutputStream(baStream);

    // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
    // Requires try/catch
    try {
      ImageIO.write(bimg, "jpg", bos);
    } 
    catch (IOException e) {
      e.printStackTrace();
    }

    // Get the byte array, which we will send out via UDP!
    byte[] image_packet = baStream.toByteArray();
    println("Total: "+image_packet.length);
    int n = 4;
    int step = image_packet.length/n;
    println("STEP = " + step);

    for (int i=0; i<n-1; i++) {
      byte[] packet = new byte[1 + step];

      packet[0] = (byte)i;
      arrayCopy(image_packet, i*step, packet, 1, packet.length-1);
      /*
      for (int j=1; j<step; j++) {
       packet[j] = image_packet[i*step+j];
       }*/
      // Send JPEG data as a datagram
      println("Sending datagram "+i+ " with " + packet.length + " bytes");
      try {
        ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName(unityIP), unityPort));
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
    }

    //for the last packet
    int leftBytes = image_packet.length-(3)*step;
    byte[] packet = new byte[1 + leftBytes];
    packet[0] = 3;
    arrayCopy(image_packet, 3*step, packet, 1, packet.length-1);
    // Send JPEG data as a datagram
    println("Sending datagram "+(n-1)+" with " + packet.length + " bytes");
    try {
      ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName(unityIP), unityPort));
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void Broadcast(int index, PImage img) {    
    // We need a buffered image to do the JPG encoding
    BufferedImage bimg = new BufferedImage( img.width, img.height, BufferedImage.TYPE_INT_RGB );

    // Transfer pixels from localFrame to the BufferedImage
    img.loadPixels();
    bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

    // Need these output streams to get image as bytes for UDP communication
    ByteArrayOutputStream baStream    = new ByteArrayOutputStream();
    BufferedOutputStream bos      = new BufferedOutputStream(baStream);

    // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
    // Requires try/catch
    try {
      ImageIO.write(bimg, "jpg", bos);
    } 
    catch (IOException e) {
      e.printStackTrace();
    }

    // Get the byte array, which we will send out via UDP!
    byte[] image_packet = baStream.toByteArray();
    println("img pck: " + image_packet.length);
    byte[] packet = new byte[1+image_packet.length];
    packet[0] =(byte)index;
    println("pck: " + packet.length);

    for (int i=0; i<image_packet.length; i++) {
      packet[i+1] = image_packet[i];
    }

    // Send JPEG data as a datagram
    println("Sending datagram with " + packet.length + " bytes");
    try {
      ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName(unityIP), unityPort));
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  //Converts the PImage to a Byte array enconded as a JPG image
  public byte[] getImageBytes(PImage img) {
    // We need a buffered image to do the JPG encoding
    BufferedImage bimg = new BufferedImage( img.width, img.height, BufferedImage.TYPE_INT_RGB );

    // Transfer pixels from localFrame to the BufferedImage
    img.loadPixels();
    bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

    // Need these output streams to get image as bytes for UDP communication
    ByteArrayOutputStream baStream    = new ByteArrayOutputStream();
    BufferedOutputStream bos      = new BufferedOutputStream(baStream);

    // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
    // Requires try/catch
    try {
      ImageIO.write(bimg, "jpg", bos);
    } 
    catch (IOException e) {
      e.printStackTrace();
    }

    // Get the byte array, which we will send out via UDP!
    byte[] image_packet = baStream.toByteArray();
    return image_packet;
  }  

  public void Broadcast(PImage img) {    
    // We need a buffered image to do the JPG encoding
    BufferedImage bimg = new BufferedImage( img.width, img.height, BufferedImage.TYPE_INT_RGB );

    // Transfer pixels from localFrame to the BufferedImage
    img.loadPixels();
    bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

    // Need these output streams to get image as bytes for UDP communication
    ByteArrayOutputStream baStream    = new ByteArrayOutputStream();
    BufferedOutputStream bos      = new BufferedOutputStream(baStream);

    // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
    // Requires try/catch
    try {
      ImageIO.write(bimg, "jpg", bos);
    } 
    catch (IOException e) {
      e.printStackTrace();
    }

    // Get the byte array, which we will send out via UDP!
    byte[] packet = baStream.toByteArray();

    // Send JPEG data as a datagram
    println("Sending datagram with " + packet.length + " bytes");
    try {
      ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName(unityIP), unityPort));
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}