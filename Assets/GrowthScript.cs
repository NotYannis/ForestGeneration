using UnityEngine;
using System.Collections;

public class GrowthScript : MonoBehaviour {
    public float growthSpeed;
    public float maxGrowth;

    private Material treeShader;
	// Use this for initialization
	void Start () {
        treeShader = gameObject.GetComponent<MeshRenderer>().material;
    }
	
	// Update is called once per frame
	void Update () {
        if (treeShader.GetFloat("_Growth") < maxGrowth)
        {
            treeShader.SetFloat("_Growth", treeShader.GetFloat("_Growth") * growthSpeed);
        }
    }
}
