using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class uiPlaneCtr : Ictr
{
    private bool m_enable;
    // Start is called before the first frame update
    void Start()
    {
        EventCenter.AddListener(EventDefine.ArriveDisplayScene, Show);
        EventCenter.AddListener(EventDefine.StartGoDefaultScene, Hide);

    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public override void Hide()
    {
        base.Hide();
        if (m_enable) {
            animator.SetBool("show", false);
            m_enable = false;
        }
    }

    public override void Show()
    {
        base.Show();
        if (!m_enable) {
            animator.SetBool("show", true);
            m_enable = true;
        }

    }
}
