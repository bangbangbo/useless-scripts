## Scripts

1. **wake** - One-command morning setup that opens apps, terminals, and browser tabs   
2. **cleanfs** - Automatically organizes the Downloads folder by file type
```bash
┌──vemacitrind㉿vemacitrind-[~]
└─$ cleanfs                 
path: /home/vemacitrind/Downloads
status: organizing files
status: organization complete
```

3. **scaffold** - Generates a standard project boilerplate and initializes Git
4. **todoctl** - Terminal-based task manager to add, list, and complete tasks
```bash
┌────────────────────────────────────────────────────────────────────────────┐
│ todoctl v1.2                                                               │
├────────────────────────────────────────────────────────────────────────────┤
│   [x] Wake up                                                              │
│   [x] Brush                                                                │
│   [ ] bath                                                                 │
│ ► [x] Go College                                                           │
├────────────────────────────────────────────────────────────────────────────┤
│ controls: ↑/k ↓/j  c check  a add  d delete  q quit                        │
└────────────────────────────────────────────────────────────────────────────┘
```

5. **pomo** - 25-minute Pomodoro focus timer with desktop notifications
<img width="1204" height="757" alt="image" src="https://github.com/user-attachments/assets/98f775ed-3404-43c1-98bd-c5bdba809ca5" />

6. **passgen** - Secure random password generator with optional clipboard support
```bash
┌──vemacitrind㉿vemacitrind-[~]
└─$ passgen     
password: t3dX8!96kHhqBYLl
status: copied to clipboard
                                                                                                    
┌──vemacitrind㉿vemacitrind-[~]
└─$  passgen 32
password: ,GiQ$N88IPG6Fk8u&AAbsyV.#f#Mb*Ab
status: copied to clipboard
```

7. **autogit** - Automatically add, commit with date/time message, and push changes

If needed, add to PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Requirements

- Linux OS
- Bash shell
- Git (for relevant scripts)
- Desktop notification support (optional)
