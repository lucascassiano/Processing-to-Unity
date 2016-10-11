/*--------------------------------------
 * ProcessingToTexture
 * version: 1.0
 * compatible with ScreenBroadcast v1.0.3
 * Creation date: September 2016;
 * 
 * This code receives multiples chunks of data on an UDP server (from Processing) and converts it to an Texture2D 
 * that will be applied to the material of gameObject that this code is attached.
 * Tutorial at:
 * https://github.com/lucascassiano/Processing-to-Unity
 * 
 * >Receives data at:
 * 127.0.0.1 : 8051
--------------------------------------*/
using UnityEngine;
using System.Collections;

using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Collections.Generic; //List

public class ProcessingToTexture : MonoBehaviour {

	// receiving Thread
	Thread receiveThread;

	// udpclient object
	UdpClient client;

	// public
	// public string IP = "127.0.0.1"; default local
	private int port; // define > init

	private bool updateTexture=false;
	Texture2D texture;
	private byte[] receivedBytesToTexture;

	byte[] chunk0, chunk1, chunk2, chunk3, chunk4, chunk5, chunk6, chunk7;

	private int lastIndex = 0;

	//Image settings
	public int width = 0;
	public int height = 0;

	// start from shell
	private static void Main()
	{
		ProcessingToTexture receiveObj=new ProcessingToTexture();
		receiveObj.init();

		string text="";
		do
		{
			text = Console.ReadLine();
		}
		while(!text.Equals("exit"));
	}
	// start from unity3d
	public void Start()
	{

		init();
	}
		

	void Update(){
		
		if (updateTexture && receivedBytesToTexture!=null) {
			//Texture2D tex = new Texture2D(1000, 400);
			Texture2D tex = new Texture2D(width, height,  TextureFormat.RGB24, false);
			tex.LoadImage(receivedBytesToTexture);
			//tex.LoadRawTextureData(receivedBytes);
			tex.Apply();
			GetComponent<Renderer>().material.mainTexture = tex;
			updateTexture = false;
		}


	}
	// init
	private void init()
	{
		// define port
		port = 8051;
		receiveThread = new Thread(
			new ThreadStart(ReceiveData));
		receiveThread.IsBackground = true;
		receiveThread.Start();

	}

	// receive thread
	private  void ReceiveData()
	{
		client = new UdpClient(port);
		while (true)
		{
			try
			{
		
				IPEndPoint anyIP = new IPEndPoint(IPAddress.Any, 0);
				byte[] receivedBytes = client.Receive(ref anyIP);

				//receivedBytes = data;

				int pkgIndex = (int)receivedBytes[0];
				print("Received Package: " + pkgIndex + " with " + (receivedBytes.Length) + " bytes");

				byte[] chunk = new byte[receivedBytes.Length - 1];
				Array.Copy(receivedBytes, 1, chunk , 0, chunk .Length);

				if(pkgIndex==0){
					updateTexture = false;
					chunk0 = chunk;
				}
				else if(pkgIndex==1){
					updateTexture = false;
					chunk1 = chunk;
				}
				else if(pkgIndex==2){
					updateTexture = false;
					chunk2 = chunk;
				}
				else if(pkgIndex==3){
					updateTexture = false;
					chunk3 = chunk;
				}
				else if(pkgIndex==4){
					updateTexture = false;
					chunk4 = chunk;
				}
				else if(pkgIndex==5){
					updateTexture = false;
					chunk5 = chunk;
				}
				else if(pkgIndex==6){
					updateTexture = false;
					chunk6 = chunk;
				}
				else if(pkgIndex==7){
					chunk7 = chunk;
						
					if(chunk0!=null && chunk1!=null && chunk2!=null && chunk3!=null && chunk4!=null && chunk5!=null && chunk6!=null){
						//Concat All
						int skip = 0;
						byte[] firstPart  = Combine(chunk0, chunk1);
						byte[] secondPart = Combine(chunk2, chunk3);
						byte[] thirdPart = Combine(chunk4, chunk5);
						byte[] fourthPart = Combine(chunk6, chunk7);

						byte[] firstHalf = Combine(firstPart,secondPart);
						byte[] secondHalf = Combine(thirdPart,fourthPart);

						receivedBytesToTexture = Combine(firstHalf, secondHalf);

						print("Update Texture received: " + receivedBytesToTexture.Length); 
						updateTexture = true;
					}
				}
			}
			catch (Exception err)
			{
				print(err.ToString());
			}
		}
	}
		

	public static byte[] Combine(byte[] first, byte[] second)
	{
		byte[] ret = new byte[first.Length + second.Length];
		Buffer.BlockCopy(first, 0, ret, 0, first.Length);
		Buffer.BlockCopy(second, 0, ret, first.Length, second.Length);
		return ret;
	}
}