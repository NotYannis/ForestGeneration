using UnityEngine;
using System.Collections;

public class GrowingTree : MonoBehaviour {

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		if(transform.localScale.x <= 1.0f){
			transform.localScale += new Vector3(0.01f, 0.01f, 0.01f);
		}
	}
}
