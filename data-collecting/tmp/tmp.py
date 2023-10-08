import tkinter as tk
from tkinter import messagebox


def confirm_action():
    result = messagebox.askquestion("Confirmation", "Do you want to proceed?")
    if result == "yes":
        # 処理を続行
        print(1)
    else:
        print(2)


root = tk.Tk()
button = tk.Button(root, text="Click me", command=confirm_action)
button.pack()
root.mainloop()
