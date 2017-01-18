using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TreeGenerator : MonoBehaviour {

	public int seed;

	public int maximumVertices = 3000;

	public int numberOfSides = 5;

	public float baseRadius = 2.0f;

	public float radiusStep = 0.3f;

	public float minimumRadius = 0.1f;

	public float branchRoundess = 0.8f;

	public float segmentLentgh = 0.3f;

	public float twisting = 20.0f;

	public float branchProbability = 0.2f;


	public Terrain leTerrain;
	public Material treeTexture;

	private float[] ringShape;

	private List<Vector3> vertexList;
	private List<Vector2> uvList;
	private List<int> triangleList;

	MeshFilter filter;
	MeshRenderer renderer;


	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetMouseButtonDown(0)){
			seed = 1;
			GameObject tree = new GameObject();
			filter = tree.AddComponent<MeshFilter>();
			renderer = tree.AddComponent<MeshRenderer>();
			renderer.material = treeTexture;

			tree.transform.position = new Vector3(Random.Range(-100, 100), 0.0f, Random.Range(-100, 100));
			tree.transform.localScale = new Vector3(0.01f, 0.01f, 0.1f);
			tree.AddComponent<GrowingTree>();
			GenerateTree(tree);
		}
	}

	public void GenerateTree(GameObject obj){
		if(vertexList == null){
			vertexList = new List<Vector3>();
			uvList = new List<Vector2>();
			triangleList = new List<int>();
		} else {
			vertexList.Clear();
			uvList.Clear();
			triangleList.Clear();
		}

		SetTreeRingShape();

		Random.InitState(seed);

		Branch(new Quaternion(), Vector3.zero, -1, baseRadius, 0.0f, obj);

		obj.transform.localRotation = transform.localRotation;

		SetTreeMesh(obj);
	}

	private void SetTreeRingShape(){
		ringShape = new float[numberOfSides + 1];

		float k = (1.0f - branchRoundess) * 0.5f;
		 for(int i = 0; i < numberOfSides; ++i){
		 	ringShape[i] = 1.0f - (Random.value - 0.5f) * k;
		 }
		 ringShape[numberOfSides] = ringShape[0];
	}

	private void Branch(Quaternion quaternion, Vector3 position, int lastRingVertexIndex, float radius, float textCoordV, GameObject obj){
		//Vector3 tmpPos = position;

		Vector3 offset = Vector3.zero;
		Vector2 textCoord = new Vector2(0.0f, textCoordV);
		float textureStepU = 1.0f / numberOfSides;
		float angInc = 2.0f * Mathf.PI * textureStepU;
		float ang = 0.0f;

		int i;
		for(i = 0; i < numberOfSides; ++i, ang += angInc){
			float r = ringShape[i] * radius;
			offset.x = r * Mathf.Cos(ang);
			offset.z = r * Mathf.Sin(ang);
			vertexList.Add(position + quaternion * offset);
			uvList.Add(textCoord);
			textCoord.x += textureStepU;
		}

		//tree ring gen
		if(lastRingVertexIndex >= 0){
			//int index = triangleList.Count;
			int currentRingVertexIndex;
            for (currentRingVertexIndex = vertexList.Count - numberOfSides - 1; currentRingVertexIndex < vertexList.Count - 1; currentRingVertexIndex++, lastRingVertexIndex++){
				triangleList.Add(lastRingVertexIndex + 1);
				triangleList.Add(lastRingVertexIndex);
				triangleList.Add(currentRingVertexIndex);
				triangleList.Add(currentRingVertexIndex);
				triangleList.Add(currentRingVertexIndex + 1);
				triangleList.Add(lastRingVertexIndex + 1);
			}
			for(i = 0; i < triangleList.Count; i++){
				Debug.Log("T : " + i + " : " + triangleList[i]);
			}
			triangleList[0] = 9;
			triangleList[1] = 5;
			triangleList[2] = 13;
		}

		radius *= radiusStep;
		if(radius < minimumRadius || vertexList.Count + numberOfSides >= maximumVertices){
			vertexList.Add(position);
			uvList.Add(textCoord + Vector2.one);
			int index = triangleList.Count;
			for(i = vertexList.Count - numberOfSides - 2; i < vertexList.Count - 2; ++i){
				triangleList.Add(i);
				triangleList.Add(vertexList.Count - 1);
				triangleList.Add(i + 1);
			}
            triangleList[index] = i;

			return;
		}

		textCoordV += 0.0625f * (segmentLentgh + segmentLentgh / radius);
		position += quaternion * new Vector3(0.0f, segmentLentgh, 0.0f);
		obj.transform.rotation = quaternion;
		float x = (Random.value - 0.5f) * twisting;
		float z = (Random.value - 0.5f) * twisting;
		obj.transform.Rotate(x, 0.0f, z);
		lastRingVertexIndex = vertexList.Count - numberOfSides - 1;

		Branch(obj.transform.rotation, position, lastRingVertexIndex, radius, textCoordV, obj);

		if(vertexList.Count + numberOfSides >= maximumVertices || Random.value > branchProbability) return;

		obj.transform.rotation = quaternion;
		x = Random.value * 70.0f - 35.0f;
		if(x > 0){
			x += 10.0f;
		}
		else {
			x -= 10.0f;
		}
		z = Random.value * 70.0f - 35.0f;
		if(z > 0){
			z += 10.0f;
		}
		else {
			z -= 10.0f;
		}
		obj.transform.Rotate(x, 0.0f, z);
		Branch(obj.transform.rotation, position, lastRingVertexIndex, radius, textCoordV, obj);
	}

	private void SetTreeMesh(GameObject obj){
		Mesh mesh = filter.sharedMesh;
		if(mesh == null){
			mesh = new Mesh();
		}
		else{
			mesh.Clear();
		}

		mesh.vertices = vertexList.ToArray();
		mesh.uv = uvList.ToArray();
		mesh.triangles = triangleList.ToArray();

		mesh.RecalculateNormals();
		mesh.RecalculateBounds();
		mesh.Optimize();

		obj.GetComponent<MeshFilter>().mesh = mesh;
	}
}
