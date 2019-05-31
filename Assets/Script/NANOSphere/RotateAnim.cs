using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateAnim : MonoBehaviour
{
    public Animator animator;

    public List<NodeLineCtr> nodeLineCtrs = new List<NodeLineCtr>();

    public int heighLightSphere=3;
    // Start is called before the first frame update
    void Start()
    {
        animator.StartPlayback();
        StartRandomPos();
    }

    // Update is called once per frame
    void Update()
    {
        
    }



    List<NodeLineCtr>  SelectSphereNode() {
        Dictionary<float, NodeLineCtr> dick = new Dictionary<float, NodeLineCtr>();
        List<float> dis = new List<float>();
        List<NodeLineCtr> temp = new List<NodeLineCtr>();

        foreach (var item in nodeLineCtrs)
        {
            dick.Add(Mathf.Abs( this.transform.position.x - item.transform.position.x),item);
            dis.Add(Mathf.Abs(this.transform.position.x - item.transform.position.x));
        }

        dis.Sort();
        dis.Reverse();
        for (int i = 0; i < heighLightSphere; i++)
        {
            temp.Add(dick[dis[i]]);
           
        }
        return temp;
    }


    private List<int> SelectNum(int num,int min,int max) {
        List<int> temp= new List<int>();
        int i = 0;

        while (temp.Count < num) {
            int Number = Random.Range(min, max);

            if (!temp.Contains(Number)) {

                temp.Add(Number);
              //  Debug.Log(Number);
            }

        }


        return temp;
        
    }


    void  HideShow() {

        List<NodeLineCtr> m_nodeLineCtrs = new List<NodeLineCtr>();
        m_nodeLineCtrs = SelectSphereNode();

        List<int> num = SelectNum(heighLightSphere, 0, 7);

        foreach (NodeLineCtr item in m_nodeLineCtrs)
        {
            item.HeighLIGHT();
            Sprite sprite = item.sprites[num[m_nodeLineCtrs.IndexOf(item)]];
            if (item.transform.position.x < this.transform.position.x)
            {
                item.nodeDescriptionImages[1].ShowDescription(sprite);
            }
            else
            {

                item.nodeDescriptionImages[0].ShowDescription(sprite);
            }
        }
    }

    void StartRandomPos() {

       HideShow();

        //Get them_Animator, which you attach to the GameObject you intend to animate.

        //Fetch the current Animation clip information for the base layer
        AnimatorClipInfo[] m_CurrentClipInfo  = animator.GetCurrentAnimatorClipInfo(0);
        //Access the current length of the clip
        float  m_CurrentClipLength = m_CurrentClipInfo[0].clip.length;
        //Access the Animation clip name
      //  Debug.Log(m_CurrentClipLength);

        float frame = animator.GetCurrentAnimatorStateInfo(0).normalizedTime;


        LeanTween.value(frame, getRandom(frame), Random.Range(0.4f, 0.5f)).setDelay(5f).setOnStart(delegate() {
            foreach (NodeLineCtr item in nodeLineCtrs)
            {
                item.DeHeight();
                item.nodeDescriptionImages[0].Hide();
                item.nodeDescriptionImages[1].Hide();
            }

        }).setOnUpdate(SetFrame).setOnComplete(delegate () {


            StartRandomPos();
        }).setEase(LeanTweenType.easeInOutSine);
    
    }

    float getRandom(float current) {
        float temp = 0;
        temp  = Random.Range(0f, 1f);
        while (Mathf.Abs(current - temp) < 0.5f) {
            temp = Random.Range(0f, 1f);
        }

        return temp;
    }


    private void SetFrame(float x)
    {
        animator.Play("NodeCenterRot", 0, x);
    }
}
