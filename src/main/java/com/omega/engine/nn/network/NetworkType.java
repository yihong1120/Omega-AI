package com.omega.engine.nn.network;

/**
 * 
 * @author Administrator
 *
 */
public enum NetworkType {
	
	BP("BP"),
	CNN("CNN"),
	ANN("ANN"),
	RNN("RNN"),
	SEQ2SEQ_RNN("SEQ2SEQ_RNN"),
	SEQ2SEQ("SEQ2SEQ"),
	TTANSFORMER("TTANSFORMER"),
	GPT("GPT"),
	YOLO("YOLO");
	
	NetworkType(String key){
		this.key = key;
	}
	
	private String key;

	public String getKey() {
		return key;
	}

}
