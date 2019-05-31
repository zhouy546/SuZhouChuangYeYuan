using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FuiCtr : MonoBehaviour
{

    public Animator animator;
    public List<GameObject> gameObjectsToToggle = new List<GameObject>();
    // Start is called before the first frame update
    void Start()
    {
        EventCenter.AddListener(EventDefine.StartGoDefaultScene, Show);
        EventCenter.AddListener(EventDefine.StartGoDisplayScene, Hide);
    }

    public void Show() {
        animator.SetBool("Show", true);

        foreach (var item in gameObjectsToToggle)
        {
            item.SetActive(true);
        }
    }

    public void Hide() {
        animator.SetBool("Show", false);
        foreach (var item in gameObjectsToToggle)
        {
            item.SetActive(false);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
