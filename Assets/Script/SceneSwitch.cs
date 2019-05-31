using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[System.Serializable]


public class SceneSwitch : MonoBehaviour
{

    public Transform DefaultSceneTrans;
    public Transform DisplaySceneTrans;
    public static SceneSwitch instance;

    public bool enableKeyBroadDebug;

    private bool isDisplayScene;
    // Start is called before the first frame update
    void Start()
    {
        EventCenter.AddListener(EventDefine.StartGoDefaultScene, HideAllNode);
        EventCenter.AddListener<string>(EventDefine.ArriveDisplayShowNode, ShowOneNode);

        if (instance == null) {
            instance = this;
        }
    }

    public void GoDisplayScene(string udp="") {

        if (isDisplayScene)
        {
            EventCenter.Broadcast(EventDefine.ArriveDisplayScene);
            EventCenter.Broadcast(EventDefine.ArriveDisplayShowNode, udp);
            EventCenter.Broadcast(EventDefine.ArriveDisplayShowNode, udp);
            EventCenter.Broadcast(EventDefine.StartGoDisplayScene);

        }
        else {
            isDisplayScene = true;
            EventCenter.Broadcast(EventDefine.StartGoDisplayScene);
            LeanTween.moveY(this.gameObject, DisplaySceneTrans.position.y, 0.5f).setOnComplete(delegate () {
                EventCenter.Broadcast(EventDefine.ArriveDisplayScene);
                EventCenter.Broadcast(EventDefine.ArriveDisplayShowNode, udp);
            }).setEase(LeanTweenType.easeInOutQuad);
        }

    }

    public void GoDefaultScene() {

        if (!isDisplayScene)
        {
            EventCenter.Broadcast(EventDefine.StartGoDefaultScene);
        }
        else
        {
            isDisplayScene = false;
            EventCenter.Broadcast(EventDefine.StartGoDefaultScene);
            LeanTween.moveY(this.gameObject, DefaultSceneTrans.position.y, 0.5f).setDelay(0.5f).setEase(LeanTweenType.easeInOutQuad);
        }
    }


    public void ShowOneNode(string udp)
    {
        foreach (var item in ValueSheet.UDP_NODE_keyValuePairs)
        {
            if (item.Key == udp)
            {
                item.Value.Show();
            }
            else {
                item.Value.Hide();
            }
        }
    }

    public void HideAllNode() {
        foreach (var item in ValueSheet.UDP_NODE_keyValuePairs)
        {
            item.Value.Hide();
        }
    }



    // Update is called once per frame
    void Update()
    {
        if (enableKeyBroadDebug)
        {
            if (Input.GetKeyDown(KeyCode.Q))
            {
                GoDisplayScene();
            }
            else if (Input.GetKeyDown(KeyCode.E)) {
                GoDefaultScene();
            }
        }
    }
}
