package com.omega.engine.nn.layer.active.jobs.sigmod;

import java.util.concurrent.ForkJoinTask;
import java.util.concurrent.RecursiveAction;

public class SigmodForwardJob extends RecursiveAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5122995462148301836L;

	private int start = 0;
	
	private int end = 0;
	
	private float[] x;
	
	private float[] y;
	
	public SigmodForwardJob(float[] x,float[] y,int start,int end) {
		this.x = x;
		this.y = y;
		this.start = start;
		this.end = end;
	}
	
	@Override
	protected void compute() {
		// TODO Auto-generated method stub
		int length = end - start + 1;
		
		if (length < 8 || length <= x.length / 8) {
			
			exeute();

		} else {

			int mid = (start + end + 1) >>> 1;
			SigmodForwardJob left = new SigmodForwardJob(x, y, start, mid - 1);
			SigmodForwardJob right = new SigmodForwardJob(x, y, mid, end);

			ForkJoinTask<Void> leftTask = left.fork();
			ForkJoinTask<Void> rightTask = right.fork();

			leftTask.join();
			rightTask.join();
			
		}
	}
	
	private void exeute() {
		
		for (int i = start; i <= end; i++) {
			
			y[i] = (float) (1.0f / (1.0f + Math.exp(-x[i])));
			
		}
		
	}
	
}
