using UnityEngine;
using System.Collections;

public class MakeGrowth : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    void OnTriggerEnter(Collider collider)
    {
        Debug.Log("ouiii");
        GrowthScript growth = collider.GetComponent<GrowthScript>();
        if(growth != null)
        {
            growth.enabled = true;
        }

    }
}
