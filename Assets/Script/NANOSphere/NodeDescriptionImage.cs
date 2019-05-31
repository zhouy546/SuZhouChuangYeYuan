using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
[RequireComponent(typeof(Animator))]
public class NodeDescriptionImage : MonoBehaviour
{
    public Image image;
    public NodeLineCtr nodeLineCtr;
    private Animator _animator;

    // Start is called before the first frame update
    void Awake()
    {
        _animator = this.GetComponent<Animator>();
        //SetImage(nodeLineCtr.sprites[0]);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void ShowDescription(Sprite sprite) {
        SetImage(sprite);

        Show();
    }

    private void Show() {
        _animator.SetBool("Show", true);
    }

    public void Hide()
    {
        _animator.SetBool("Show", false);
    }

    private void SetImage(Sprite sprite) {

        float width = sprite.rect.width/100f;
        float height = sprite.rect.height/100f;

        image.sprite = sprite;

        RectTransform rectTrans = this.GetComponent<RectTransform>();

        rectTrans.sizeDelta = new Vector2(width, height);
    }
}
