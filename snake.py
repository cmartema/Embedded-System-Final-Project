import tkinter
import random

# Constants
ROWS = 25
COLS = 25
TILE_SIZE = 25

WINDOW_HEIGHT = TILE_SIZE * ROWS
WINDOW_WIDTH = TILE_SIZE * COLS

class Tile:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        return f'Tile({self.x}, {self.y})'

# Setting up the game window
window = tkinter.Tk()
window.title("Snake")
window.resizable(False, False) # Prevent resizing from user

# Setting up the game canvas
background_color = "black" # Background color of the window (#000000)
canvas = tkinter.Canvas(window, bg = background_color, width=WINDOW_WIDTH, height=WINDOW_HEIGHT, borderwidth=0, highlightthickness=0) # Create a canvas for drawing
canvas.pack()
window.update()

# Centering the game window
window_width = window.winfo_width() # Get the width of the window
window_height = window.winfo_height() # Get the height of the window
screen_width = window.winfo_screenwidth() # Get the width of the screen
screen_height = window.winfo_screenheight() # Get the height of the screen
x_pos = int(screen_width/2 - window_width/2) # Calculate the x position of the window
y_pos = int(screen_height/2 - window_height/2) # Calculate the y position of the window
window.geometry(f"{window_width}x{window_height}+{x_pos}+{y_pos}") # Set the position of the window

# initialize game variables
snake = Tile(5*TILE_SIZE, 5*TILE_SIZE) # Snake head as a single tile
snake_body = [] # Snake body as a list of tiles
food = Tile(10*TILE_SIZE, 10*TILE_SIZE) # Food as a single tile
dx = 0 # Change in x position (velocity)
dy = 0 # Change in y position (velocity)
game_over = False
game_score = 0


# def generate_food(snake_body):
#     possible_food_positions = []
    
#     # * TILE_SIZE
#     # Generate all possible food positions (does include the snake body)
#     for row in range(0, COLS- 1):
#         for col in range(0, ROWS - 1):
#             for tile in snake_body:
#                 print("tile:", tile)
#             isLocationValid = all([row != tile.y or col != tile.x for tile in snake_body])
#             if isLocationValid:
#                 possible_food_positions.append((row*TILE_SIZE, col*TILE_SIZE))
    
#     return random.choice(possible_food_positions)


def change_direction(event):
    #print(event) # Print the key pressed on the keyboard
    #print(event.keysym) # Print the key symbol of the key pressed on the keyboard (right, left, up, down...etc)
    global dx, dy, game_over

    if game_over:
        return # Exit the function if the game is over (Won't change the direction of the snake after game over)

    if (event.keysym == "Up") and (dy != 1):
        dx = 0
        dy = -1
    elif (event.keysym == "Down") and (dy != -1):
        dx = 0
        dy = 1 
    elif (event.keysym == "Left") and (dx != 1):
        dx = -1
        dy = 0   
    elif (event.keysym == "Right") and (dx != -1):
        dx = 1
        dy = 0
    
def move_snake():
    global snake, snake_body, food, game_over, game_score

    if(game_over): # Exit the function if the game is over(No need to move the snake after game over)
        return

    # Detect collision with the window boundaries
    if (snake.x < 0) or (snake.x >= WINDOW_WIDTH) or (snake.y < 0) or (snake.y >= WINDOW_HEIGHT):  
        game_over = True
        return  # Exit the function if the snake hits the window boundaries (Game Over)
    
    for tile in snake_body:
        if (snake.x == tile.x) and (snake.y == tile.y):
            game_over = True
            return # Exit the function if the snake hits itself (Game Over)

    # Detect collision with snake head and food
    if (snake.x == food.x) and (snake.y == food.y):
        snake_body.append(Tile(food.x, food.y)) # Add a new tile to the snake body
        food.x = random.randint(0, COLS-1) * TILE_SIZE # Random x position of the food
        food.y = random.randint(0, ROWS-1) * TILE_SIZE # Random y position of the food
        # result = generate_food(snake_body) # Generate a new food position
        game_score += 1
    
    # Move the snake body
    for i in range(len(snake_body)-1, -1, -1):
        tile = snake_body[i]

        if (i == 0): # Move the first tile of the snake body to the snake head's position
            tile.x = snake.x
            tile.y = snake.y
        else: # Move the rest of the tiles to the previous tile's position
            tile.x = snake_body[i-1].x
            tile.y = snake_body[i-1].y

    snake.x += dx*TILE_SIZE # Move the snake by dx Tiles (625 px)
    snake.y += dy*TILE_SIZE # Move the snake by dy Tiles (625 px)

def draw():
    global snake, food, snake_body, game_over, game_score

    # Move the snake before drawing it
    move_snake() # The snake moves 1 tile every 100 milliseconds (10 frames per second)

    # Clear the canvas before drawing game new state
    canvas.delete("all")

    # Draw the food
    food_color = "red" # Color of the food (#FF0000)
    canvas.create_rectangle(food.x, food.y, food.x + TILE_SIZE, food.y + TILE_SIZE, fill=food_color)

    # Draw the snake
    snake_color = "limegreen" # Color of the snake (#32CD32)
    canvas.create_rectangle(snake.x, snake.y, snake.x + TILE_SIZE, snake.y + TILE_SIZE, fill=snake_color)

    for tile in snake_body:
        canvas.create_rectangle(tile.x, tile.y, tile.x + TILE_SIZE, tile.y + TILE_SIZE, fill=snake_color) # Draw the snake body
        
    # Draw the game score
    if (game_over): # Display the game over text if the game is over
        game_over_text = f"Game Over: Score = {game_score}"
        game_over_color = "white" # Color of the game over text (#FFFFFF)
        canvas.create_text(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, text=game_over_text, fill=game_over_color, font=("Arial", 24), anchor="center")
    else: # Display the game score if the game is not over
        game_score_text = f"Score = {game_score}"
        game_score_color = "white"
        canvas.create_text(60, 10, text=game_score_text, fill=game_score_color, font=("Arial", 10), anchor="ne")

    window.after(100, draw) # Call the draw function every 100 milliseconds = 1/10 seconds (10 frames per second)

draw()

window.bind("<KeyPress>", change_direction) # Bind the on_key_press function to the key press event
window.mainloop()



