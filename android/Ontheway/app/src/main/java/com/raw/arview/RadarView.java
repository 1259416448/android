package com.raw.arview;

import android.graphics.Color;
import android.location.Location;

import com.raw.utils.PaintUtils;

import arvix.cn.ontheway.ui.ARView;


public class RadarView{
	/** The screen */
	public DataView view;
	/** The radar's range */
	float range;
	/** Radius in pixel on screen */
	public static float RADIUS = 40;
	/** Position on screen */
	static float originX = 0 , originY = 0;
	
	/**
	 * You can change the radar color from here.
	 *   */
	static int radarColor = Color.argb(100, 220, 0, 0);
	Location currentLocation = new Location("provider");
	Location destinedLocation = new Location("provider");

	/*
	 * pass the same set of coordinates to plot POI's on radar
	 * */
	// SF Art Commission, SF Dept. of Public Health, SF Ethics Comm, SF Conservatory of Music, All Star Cafe, Magic Curry Cart, SF SEO Marketing, SF Honda, 
	// SF Mun Transport Agency, SF Parking Citation, Mayors Office of Housing, SF Redev Agency, Catario Patrice, Bank of America , SF Retirement System, Bank of America Mortage,
	// Writers Corp., Van Nes Keno Mkt.
	double[] latitudes = new double[]  {30.544359,30.5477123260498,30.544364,30.54317283630371,30.54336547851562,30.54634165456429,30.54317283630371,30.54156140677093,30.54473495483398,
			30.54166886912281,30.5425040698918,30.54663222363656,30.54336547851562,30.5478687286377,30.54803591569739,30.5477123260498,30.5478687286377,30.5478687286377,
			30.54336547851562,30.54336547851562,30.54336547851562,30.54336547851562,30.54336547851562,30.54336547851562,30.54336547851562,30.54336547851562,30.54212188720703,
			30.54336547851562,30.54336547851562,30.54336547851562}
			;
	double[] longitudes = new double[] {104.067916,104.067756652832,104.067881,104.0727996826172,104.0665969848633,104.0672473087467,
			104.0727996826172,104.072528626501,104.0649642944336,104.0636399833103,104.071522075177,
			104.0671997883852,104.0665969848633,104.0697860717773,104.0682198142918,104.067756652832,
			104.0697860717773,104.0697860717773,104.0665969848633,104.0665969848633,104.0665969848633,
			104.0665969848633,104.0665969848633,104.0665969848633,104.0665969848633,104.0665969848633,104.0665283203125,104.0665969848633,104.0665969848633,104.0665969848633}
			;

	public float[][] coordinateArray = new float[latitudes.length][2];
	
	float angleToShift;
	public float degreetopixel;
	public float bearing;
	public float circleOriginX;
	public float circleOriginY;
	private float mscale;
	
	
	public float x = 0;
	public float y = 0;
	public float z = 0;

	float  yaw = 0;
	double[] bearings;
	ARView arView = new ARView();
	
	public RadarView(DataView dataView, double[] bearings){
		this.bearings = bearings;
		calculateMetrics();
	}
	
	public void calculateMetrics(){
		circleOriginX = originX + RADIUS;
		circleOriginY = originY + RADIUS;
		
		range = (float)arView.convertToPix(10) * 50;
		mscale = range / arView.convertToPix((int)RADIUS);
	}
	
	public void paint(PaintUtils dw, float yaw) {
		
//		circleOriginX = originX + RADIUS;
//		circleOriginY = originY + RADIUS;
		this.yaw = yaw;
//		range = arView.convertToPix(10) * 1000;		/** Draw the radar */
		dw.setFill(true);
		dw.setColor(radarColor);
		dw.paintCircle(originX + RADIUS, originY + RADIUS, RADIUS);

		/** put the markers in it */
//		float scale = range / arView.convertToPix((int)RADIUS);
		/**
		 *  Your current location coordinate here.
		 * */
		currentLocation.setLatitude(37.774968);
		currentLocation.setLongitude(-122.41941);

		
		for(int i = 0; i <latitudes.length;i++){
			destinedLocation.setLatitude(latitudes[i]);
			destinedLocation.setLongitude(longitudes[i]);
			convLocToVec(currentLocation, destinedLocation);
			float x = this.x / mscale;
			float y = this.z / mscale;

			
			if (x * x + y * y < RADIUS * RADIUS) {
				dw.setFill(true);
				dw.setColor(Color.rgb(255, 255, 255));
				dw.paintRect(x + RADIUS, y + RADIUS, 2, 2);
			}
		}
	}

	public void calculateDistances(PaintUtils dw, float yaw){
		currentLocation.setLatitude(19.474037);
		currentLocation.setLongitude(72.800388);
		for(int i = 0; i <latitudes.length;i++){
			if(bearings[i]<0){
				bearings[i] = 360 - bearings[i];
			}
			if(Math.abs(coordinateArray[i][0] - yaw) > 3){
				angleToShift = (float)bearings[i] - this.yaw;
				coordinateArray[i][0] = this.yaw;
			}else{
				angleToShift = (float)bearings[i] - coordinateArray[i][0] ;
				
			}
			destinedLocation.setLatitude(latitudes[i]);
			destinedLocation.setLongitude(longitudes[i]);
			float[] z = new float[1];
			z[0] = 0;
			Location.distanceBetween(currentLocation.getLatitude(), currentLocation.getLongitude(), destinedLocation.getLatitude(), destinedLocation.getLongitude(), z);
			bearing = currentLocation.bearingTo(destinedLocation);

			this.x = (float) (circleOriginX + 40 * (Math.cos(angleToShift)));
			this.y = (float) (circleOriginY + 40 * (Math.sin(angleToShift)));


			if (x * x + y * y < RADIUS * RADIUS) {
				dw.setFill(true);
				dw.setColor(Color.rgb(255, 255, 255));
				dw.paintRect(x + RADIUS - 1, y + RADIUS - 1, 2, 2);
			}
		}
	}
	
	/** Width on screen */
	public float getWidth() {
		return RADIUS * 2;
	}

	/** Height on screen */
	public float getHeight() {
		return RADIUS * 2;
	}
	
	
	public void set(float x, float y, float z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public void convLocToVec(Location source, Location destination) {
		float[] z = new float[1];
		z[0] = 0;
		Location.distanceBetween(source.getLatitude(), source.getLongitude(), destination
				.getLatitude(), source.getLongitude(), z);
		float[] x = new float[1];
		Location.distanceBetween(source.getLatitude(), source.getLongitude(), source
				.getLatitude(), destination.getLongitude(), x);
		if (source.getLatitude() < destination.getLatitude())
			z[0] *= -1;
		if (source.getLongitude() > destination.getLongitude())
			x[0] *= -1;

		set(x[0], (float) 0, z[0]);
	}
}