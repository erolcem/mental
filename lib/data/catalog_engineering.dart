// data/catalog_engineering.dart — the engineering constellation.
// Part of skill_data.dart: one Skill tree, governed by the catalog
// laws (see skill_data.dart + test/skill_data_test.dart). Every star:
// id, label, tier, requires, proof (completion standard), hours
// (researched effort), branch, guide (the exact work, step by step).
part of 'skill_data.dart';

final Skill engineeringTree = Skill('engineering', 'Engineering', '⚙',
        'Build Your Own Computer, OS & Distributed System', [
      _n('eg1', 'CS50 + Python', 1, null,
          'Every problem set passing the autograder', 120, 'Foundations',
          'Harvard CS50x, free on edX: all 10 problem sets through the '
              'autograder, no copied code. Then Automate the Boring Stuff '
              '(free online) until you have written five small Python tools '
              'you actually use.'),
      _n('eg2', 'C (K&R, every exercise)', 2, 'eg1',
          'Exercises in a public repo', 120, 'Foundations',
          'K&R second edition, every exercise, compiled with -Wall -Wextra '
              'and run under valgrind — zero leaks accepted. Push each '
              'chapter to a public repo with a README noting what bit you. '
              'CS50\'s memory lectures fill the gaps.'),
      _n('eg3', 'Engineering Mathematics (LinAlg + ODEs)', 2, 'eg1',
          'Strang + ODE problem sets; 3 applications to real circuits '
              'written up', 200, 'Foundations',
          'Strang\'s 18.06 (free MIT OCW, his lectures + exams) plus an ODE '
              'course\'s problem sets. Apply both: write up RC/RLC circuit '
              'response, a coupled-oscillator mode analysis and a Markov '
              'steady-state, maths → plot → sentence.'),
      _n('eg19', 'Unix craft: shell, git, tooling', 2, 'eg1',
          'MIT Missing Semester exercises; dotfiles + 10 scripting katas '
              'public', 60, 'Foundations',
          'MIT\'s The Missing Semester, all lectures + exercises: shell, '
              'tmux, git internals, debugging tools. Build your dotfiles repo '
              'from scratch (no framework), and solve 10 shell katas '
              '(cmdchallenge.com) with one-liners you can explain.'),
      // — Software systems —
      _n('eg5', 'Data Structures & Algorithms', 3, 'eg2',
          'CLRS core + 150 LeetCode, timed log', 300, 'Software',
          'CLRS core chapters (sorting, trees, graphs, DP) implementing '
              'every structure from scratch in C or Python before using any '
              'library. Then 150 LeetCode (50 easy/75 medium/25 hard) with a '
              'timed log; re-solve every failed problem a week later.'),
      _n('eg21', 'Compilers (Crafting Interpreters)', 4, 'eg5',
          'Both jlox and clox complete; one language feature of your own '
              'added', 150, 'Software',
          'Nystrom\'s Crafting Interpreters (free online): build jlox '
              'completely, then clox with its bytecode VM and GC. Finish by '
              'designing and adding one feature of your own — pattern '
              'matching, pipes, decorators — with tests.'),
      _n('eg7', 'Computer Systems (CS:APP + labs)', 4, 'eg4',
          'Bomb lab + malloc lab complete', 250, 'Software',
          'CS:APP (Bryant & O\'Hallaron) with CMU\'s self-study labs, all '
              'free: data lab, bomb lab (defuse it with gdb alone), attack '
              'lab, cache lab, malloc lab. The bomb and malloc labs are the '
              'proof — keep your write-ups.'),
      _n('eg10', 'Operating Systems (OSTEP)', 5, ['eg5', 'eg7'],
          'All projects: shell, malloc, scheduler', 250, 'Software',
          'OSTEP (free at ostep.org) cover to cover with its projects: '
              'write a shell with pipes/redirects, a malloc, an MLFQ '
              'scheduler simulation, and the concurrency projects with '
              'actual pthreads. Every chapter\'s homework simulator run.'),
      _n('eg11', 'Networking: sockets to HTTP server', 6, 'eg5',
          "Beej's guide + your server survives a load test", 100, 'Software',
          'Beej\'s Guide to Network Programming (free), then build an HTTP/'
              '1.1 server in C or Rust from raw sockets: static files, '
              'keep-alive, a thread pool. It must survive wrk with 1,000 '
              'concurrent connections without dropping valid requests.'),
      _n('eg14', 'Database Internals (CMU 15-445)', 7, 'eg10',
          'Buffer pool + B+tree + executor passing tests', 200, 'Software',
          'CMU 15-445 (Pavlo\'s lectures free on YouTube) with the BusTub '
              'projects: buffer pool manager, B+tree index, query executors, '
              'concurrency control — passing the public test suites. Read '
              'the SQLite architecture doc as dessert.'),
      _n('eg16', 'Distributed Systems (DDIA + MIT 6.824)', 9,
          ['eg11', 'eg14'],
          'Raft implementation passing the labs', 300, 'Software',
          'Read Designing Data-Intensive Applications with margin notes. '
              'Then MIT 6.824 (free lectures + labs): MapReduce, then Raft — '
              'your implementation must pass the 6.824 test harness '
              'including the unreliable-network and snapshot suites.'),
      _n('eg27', 'ML from scratch → deployed', 8, ['eg5', 'eg3'],
          'Backprop implemented from scratch (NumPy); one fast.ai model '
              'trained and served publicly', 200, 'Software',
          'fast.ai Practical Deep Learning part 1, then close the black box: '
              'implement a 2-layer net + backprop in pure NumPy, gradient-'
              'checked. Train one real model on your own data and serve it '
              'behind your own HTTP endpoint with honest eval numbers.'),
      // — Hardware & embedded —
      _n('eg4', 'Digital Design & Comp. Arch. (Harris & Harris)', 3, 'eg2',
          'HDL exercises; a single-cycle CPU running in the simulator',
          200, 'Hardware',
          'Harris & Harris Digital Design and Computer Architecture: gates '
              '→ FSMs → a single-cycle RISC-V/MIPS CPU in Verilog or their '
              'simulator, running real compiled programs. Every end-of-'
              'chapter HDL exercise for ch. 2–7.'),
      _n('eg9', 'Nand2Tetris I: CPU from NAND gates', 5, 'eg4',
          'Working Hack computer in the simulator', 100, 'Hardware',
          'nand2tetris.org projects 1–6, free: build every chip from NAND '
              'up — ALU, registers, RAM, the Hack CPU — in their HDL, then '
              'hand-assemble two programs and watch your computer run them. '
              'No skipping the assembler.'),
      _n('eg12', 'Embedded: bare-metal STM32', 6, 'eg8',
          'Blink→UART→interrupt drivers from the datasheet', 150, 'Hardware',
          'A \$15 STM32 Nucleo board, no HAL: from the reference manual '
              'alone, write the linker script and startup code, blink via '
              'registers, then UART and timer-interrupt drivers. Debug with '
              'openocd/gdb; every register write commented with the manual '
              'page.'),
      _n('eg13', 'Nand2Tetris II: compiler + OS', 7, ['eg9', 'eg10', 'eg21'],
          'Tetris runs on your own stack', 200, 'Hardware',
          'Projects 7–12: VM translator, Jack compiler, and the Jack OS '
              '(memory, screen, keyboard libraries). Finish by running a '
              'game — Tetris or Pong — where every layer from NAND to '
              'game-loop is yours.'),
      _n('eg15', 'Write an RTOS in C on real hardware', 8, ['eg12', 'eg13'],
          'Preemptive scheduler + mutexes demoed', 250, 'Hardware',
          'On your STM32: context switch in assembly (PendSV), a preemptive '
              'round-robin scheduler, mutexes with priority inheritance, and '
              'a message queue — then demo three tasks sharing the UART '
              'without corruption, filmed with the logic analyzer trace.'),
      _n('eg17', 'Autonomous robot on ROS 2', 9, ['eg15', 'eg24', 'eg26'],
          'Navigates an unseen room', 300, 'Hardware',
          'A diff-drive base (kit or your own PCB), lidar, ROS 2 Nav2 stack: '
              'SLAM a map, then autonomous point-to-point in a room the '
              'robot has never seen, three runs filmed uncut. Your PID inner '
              'loop from the control node, not a black box.'),
      // — Electronics & signals —
      _n('eg6', 'Circuit Analysis', 3, 'eg3',
          'Breadboard measurements match theory', 150, 'Electronics',
          'Work The Art of Electronics ch. 1–2 problems or Sedra-level DC/AC '
              'analysis: node/mesh, Thévenin, RC/RL transients, resonance. '
              'Build 10 of them on a breadboard and show measured vs '
              'predicted within component tolerance, logged.'),
      _n('eg8', 'Signals & Systems (Oppenheim)', 4, 'eg6',
          'Fourier problem sets + a working filter', 200, 'Electronics',
          'Oppenheim & Willsky with MIT OCW 6.003 problem sets: LTI, '
              'convolution, Fourier series/transforms, sampling. Then design '
              'an active low-pass filter, build it, and show its measured '
              'Bode plot against your maths.'),
      _n('eg23', 'Electronics II: transistors & op-amps', 5, 'eg8',
          'AoE labs: 5 circuits built incl. a discrete audio amp, measured '
              'against spec', 200, 'Electronics',
          'The Art of Electronics ch. 2–4 with Learning the Art of '
              'Electronics labs: BJT biasing, followers, current mirrors, '
              'op-amp circuits. Build five — ending with a discrete class-AB '
              'audio amp — and measure gain, clipping and distortion against '
              'your design targets.'),
      _n('eg24', 'Control Theory: feedback & PID', 5, 'eg8',
          'Inverted pendulum or line-follower stabilised; step response '
              'matches your model', 150, 'Electronics',
          'Åström & Murray\'s Feedback Systems (free PDF) ch. 1–7 + Brian '
              'Douglas\'s lectures. Model one real plant (motor speed or '
              'pendulum), design a PID in simulation, then stabilise the '
              'physical thing and overlay measured vs predicted step '
              'response.'),
      _n('eg26', 'PCB design: a board you shipped', 7, 'eg23',
          'KiCad board fabbed, assembled, brought up; one respin documented',
          100, 'Electronics',
          'Learn KiCad with Contextual Electronics\' free Getting to Blinky. '
              'Design a real 2-layer board (a sensor breakout or your RTOS '
              'carrier), get it fabbed cheaply, hand-solder, bring it up '
              'with a bring-up checklist — and document the respin, because '
              'there will be one.'),
      // — Craft: security & shipping —
      _n('eg20', 'Security fundamentals (CTF training)', 7,
          ['eg11', 'eg19'],
          'picoCTF 2000+ points or pwn.college belt; 10 challenge '
              'write-ups', 120, 'Craft',
          'pwn.college\'s free dojo (start with Program Security) or grind '
              'picoCTF to 2,000+ points: memory corruption, web, crypto, '
              'reversing. Write up 10 solved challenges properly — '
              'vulnerability, exploit, fix — on a blog. White-hat rules '
              'absolute: only sanctioned targets.'),
      _n('eg25', 'Software craft: tests, CI, review', 5, ['eg5', 'eg19'],
          'A project refactored under test coverage with CI + one external '
              'code review addressed', 100, 'Craft',
          'Take your messiest working project. Add a test suite (unit + one '
              'integration path), wire CI (GitHub Actions) to run it on '
              'every push, refactor mercilessly behind the green bar, and '
              'ask one stranger (r/codereview, a Discord) for a real review '
              '— then address every comment.'),
      _n('eg22', 'Ship it: a real networked product', 8,
          ['eg11', 'eg14', 'eg25'],
          'Deployed app with real users; monitoring + honest postmortem',
          200, 'Craft',
          'Build and deploy something 10 strangers actually use (a tool, a '
              'game server, an API): TLS, backups, uptime monitoring, error '
              'tracking. Run it for a month, break something, fix it, and '
              'write the honest postmortem including the graph of the '
              'outage.'),
      // — Convergence —
      _n('eg18', 'Crown: 3-node cluster of your kernel + KV store', 10,
          ['eg16', 'eg17', 'eg20', 'eg22', 'eg27'],
          'Kill a node live — the system survives', 400, 'Convergence',
          'The capstone: your Raft from 6.824 turned into a real replicated '
              'KV store, running on three physical machines (Pis count), '
              'fronted by your own HTTP server, monitored. Demo on film: '
              'writes flowing, pull a node\'s power, writes still flowing, '
              'node rejoins and catches up.'),
]);
