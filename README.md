# Dynamic Optimization of Random Access in Deadline-Constrained Broadcasting

[Aoyu Gong](https://aygong.com/), Yijin Zhang, Lei Deng, Fang Liu, [Jun Li](http://www.deepiiotlab.com/), Feng Shu

[`IEEE`](https://ieeexplore.ieee.org/document/10025558) | [`Technical Report`](https://aygong.com/docu/pomdpbroadcast.pdf) | [`BibTeX`](#Citation)

<div align="center">
<p>
<img src="assets/protocol.jpg" width="500"/>
</p>
</div>
<table>
      <tr><td><em>Figure: An example of the working procedure of the dynamic control scheme for N = 8, D = 6.</em></td></tr>
</table>
This paper considers dynamic optimization of random access in deadline-constrained broadcasting with frame-synchronized traffic. Under the non-retransmission setting, we define a dynamic control scheme that allows each active node to determine the transmission probability based on the local knowledge of current delivery urgency and contention intensity (i.e., the number of active nodes). For an idealized environment where the contention intensity is completely known, we develop a Markov Decision Process (MDP) framework, by which an optimal scheme for maximizing the timely delivery ratio (TDR) can be explicitly obtained. For a realistic environment where the contention intensity is incompletely known, we develop a Partially Observable MDP (POMDP) framework, by which an optimal scheme can only in theory be found. To overcome the infeasibility in obtaining an optimal or near-optimal scheme from the POMDP framework, we investigate the behaviors of the optimal scheme for extreme cases in the MDP framework, and leverage intuition gained from these behaviors together with an approximation on the contention intensity knowledge to propose a heuristic scheme for the realistic environment with TDR close to the maximum TDR in the idealized environment. We further generalize the heuristic scheme to support retransmissions. Numerical results are provided to validate our study.



## Configuration

You can reproduce our experiments using **MATLAB R2021a**.

- Clone the repository: `git clone https://github.com/aygong/deadline-constrained-broadcasting.git`

- Run the script: `main_without_retran.m` or `main_with_retran.m`

> The code may be compatible with the previous versions of MATLAB.




## Folder Structure

```bash
./deadline-constrained-broadcasting/
├── README.md
|
├── function_computing.m     # Compute the MDP and POMDP functions
|
├── main_without_retran.m    # Compare without retransmissions
├── idea_opt_ana.m           # Analyze the optimal scheme (idealized)
├── idea_opt_sim.m           # Simulate the optimal scheme (idealized)
├── idea_myo_ana.m           # Analyze the myopic scheme (idealized)
├── idea_myo_sim.m           # Simulate the myopic scheme (idealized)
├── real_heu_sim.m           # Simulate the proposed heuristic scheme (realistic)
├── real_sta_ana.m           # Analyze the optimal static scheme (realistic)
├── real_sta_sim.m           # Simulate the optimal static scheme (realistic)
├── real_myo_sim.m           # Simulate the myopic scheme (realistic)
|
├── main_with_retran.m       # Compare with retransmissions
├── subframe_dividing.m      # Divide a frame into consecutive subframes
├── real_heuR_sim.m          # Simulate the proposed heuristic scheme (realistic)
└── real_staR_sim.m          # Simulate the optimal static scheme (realistic)
```



## Citation

If you find the code helpful, please consider citing our paper:

```
@ARTICLE{dynamic2023gong,
  title={Dynamic optimization of random access in deadline-constrained broadcasting},
  author={Gong, Aoyu and Zhang, Yijin and Deng, Lei and Liu, Fang and Li, Jun and Shu, Feng},
  journal={IEEE Trans. Netw. Sci. Eng.},
  year={2023},
  volume={},
  number={},
  pages={1-15},
}
```
