using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Particle_Ctr : MonoBehaviour
{
    public ParticleSystem _particleSystem;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(PlayParticle());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private IEnumerator PlayParticle() {
        yield return new WaitForSeconds(5f);
        _particleSystem.Play();
    }
}
