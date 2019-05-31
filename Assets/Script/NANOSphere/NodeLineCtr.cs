using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NodeLineCtr : MonoBehaviour
{
    public GameObject G_LineRender;

    public List<Sprite> sprites = new List<Sprite>();

    public List< Transform >TargetNodeTransform = new List<Transform>();

    public List<Line> lines = new List<Line>();

    public NodeDescriptionImage[] nodeDescriptionImages = new NodeDescriptionImage[2];

    public SphereCtr sphereCtr;

    private float WaveIntensity = 1f;
    private float Y_StartLocalPos;
    private float speed;

    float RandomStart = 0;

    public bool b = false;
    void Awake() {

        foreach (Transform item in TargetNodeTransform)
        {
            GameObject g = Instantiate(G_LineRender);
            g.transform.SetParent(this.transform);
            lines.Add(g.GetComponent<Line>());
        }
        RandomStart = Random.Range(-Mathf.PI, Mathf.PI);
        speed = Random.Range(0.1f, 2f);
        WaveIntensity = Random.Range(0.1f, 0.3f);
        Y_StartLocalPos = this.transform.localPosition.y;


        b = true;
    }

    // Start is called before the first frame update
    void Start()
    {
       
    }

    // Update is called once per frame
    void Update()
    {
        if (b) {
            UpdateLine();
            UpdateMovement();
        }

    }

    public void HeighLIGHT()
    {
        sphereCtr.HeighLight();

    }

    public void DeHeight() {
        sphereCtr.DeHeight();
    }


    public void UpdateLine() {
        foreach (var item in lines)
        {
            foreach (var linerender in item.lineRenderers)
            {
                Vector3[] pos = new Vector3[2];

                pos[0] = this.transform.position;
                pos[1] = TargetNodeTransform[lines.IndexOf(item)].position;

                linerender.SetPositions(pos);
            }
        }
    }

    public void UpdateMovement() {
        //float y = 

        float y = Y_StartLocalPos + WaveIntensity * Mathf.Sin(Time.time*speed + RandomStart);

        Vector3 LocalPos = new Vector3(this.transform.localPosition.x, y , this.transform.localPosition.z);

        this.transform.localPosition = LocalPos;
    }

}
