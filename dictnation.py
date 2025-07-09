import tkinter as tk

def on_button_click():
    print("Button clicked!")

# Create the main window
root = tk.Tk()
root.title("Dictnation")
root.geometry("300x200")  # Set the window size

# Create a button and place it in the center
button = tk.Button(root, text="Click Me", command=on_button_click)
button.pack(expand=True)

# Run the application
root.mainloop()
