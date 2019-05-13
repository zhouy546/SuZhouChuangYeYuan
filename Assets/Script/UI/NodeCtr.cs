using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class NodeCtr : Ictr
{

    private bool m_enable;
    public string udp;
    // Start is called before the first frame update
    void Start()
    {
        ValueSheet.UDP_NODE_keyValuePairs.Add(udp, this);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public override void Hide()
    {
        if (m_enable) {
            m_enable = false;
            base.Hide();
            animator.SetBool("show", false);
        }

    }

    public override void Show()
    {
        if (!m_enable) {
            m_enable = true;
            base.Show();
            animator.SetBool("show", true);
        }

    }

}
