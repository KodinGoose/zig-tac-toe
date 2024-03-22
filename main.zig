const std = @import("std");

fn checkForWinner(tiles: *[3][3]u8, symbol: u8) bool {
    if (tiles.*[0][0] == symbol and tiles.*[0][1] == symbol and tiles.*[0][2] == symbol) {
        return true;
    } else if (tiles.*[1][0] == symbol and tiles.*[1][1] == symbol and tiles.*[1][2] == symbol) {
        return true;
    } else if (tiles.*[2][0] == symbol and tiles.*[2][1] == symbol and tiles.*[2][2] == symbol) {
        return true;
    } else if (tiles.*[0][0] == symbol and tiles.*[1][0] == symbol and tiles.*[2][0] == symbol) {
        return true;
    } else if (tiles.*[0][1] == symbol and tiles.*[1][1] == symbol and tiles.*[2][1] == symbol) {
        return true;
    } else if (tiles.*[0][2] == symbol and tiles.*[1][2] == symbol and tiles.*[2][2] == symbol) {
        return true;
    } else if (tiles.*[0][0] == symbol and tiles.*[1][1] == symbol and tiles.*[2][2] == symbol) {
        return true;
    } else if (tiles.*[0][2] == symbol and tiles.*[1][1] == symbol and tiles.*[2][0] == symbol) {
        return true;
    } else {
        return false;
    }
}

fn printBoard(tiles: *[3][3]u8, stdout: anytype) !void {
    try stdout.writeAll("\x1B[2J\x1B[H");
    try stdout.print(
        \\   1 2 3
        \\
        \\1  {c}|{c}|{c}
        \\   -+-+-
        \\2  {c}|{c}|{c}
        \\   -+-+-
        \\3  {c}|{c}|{c}
        \\
    , .{
        tiles[0][0],
        tiles[0][1],
        tiles[0][2],
        tiles[1][0],
        tiles[1][1],
        tiles[1][2],
        tiles[2][0],
        tiles[2][1],
        tiles[2][2],
    });
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var tiles = [3][3]u8{ [_]u8{ ' ', ' ', ' ' }, [_]u8{ ' ', ' ', ' ' }, [_]u8{ ' ', ' ', ' ' } };
    var player_turn = true;
    var index1: u8 = undefined;
    var index2: u8 = undefined;
    var buffer: [3]u8 = undefined;
    var input: []u8 = undefined;
    var turn: u4 = 0;

    // main loop
    while (true) {
        try printBoard(&tiles, &stdout);

        if (player_turn) {
            try stdout.writeAll("Player 1\n");

            while (true) {
                try stdout.writeAll("Indexes: ");
                input = (stdin.readUntilDelimiterOrEof(buffer[0..], '\n') catch {
                    try stdout.writeAll("Invalid input. Give two indexes. Example: 11\n");
                    try stdin.skipUntilDelimiterOrEof('\n');
                    continue;
                }).?;
                if (input.len < 2) {
                    try stdout.writeAll("Invalid input. Give two indexes. Example: 11\n");
                    continue;
                }
                index1 = input[1];
                index2 = input[0];

                if ((index1 == 'q' or index1 == 'Q') and (index2 == 'q' or index2 == 'Q')) {
                    return;
                }

                if (index1 > 51 or index2 > 51 or index1 < 49 or index2 < 49) {
                    try stdout.writeAll("Invalid input. Invalid indexes.\n");
                    continue;
                }

                index1 -= 49;
                index2 -= 49;

                if (tiles[index1][index2] != ' ') {
                    try stdout.writeAll("Invalid input. Cannot place there.\n");
                    continue;
                }

                break;
            }

            tiles[index1][index2] = 'O';
        } else {
            try stdout.writeAll("Player 2\n");

            while (true) {
                try stdout.writeAll("Indexes: ");
                input = (stdin.readUntilDelimiterOrEof(buffer[0..], '\n') catch {
                    try stdout.writeAll("Invalid input. Give two indexes. Example: 11\n");
                    try stdin.skipUntilDelimiterOrEof('\n');
                    continue;
                }).?;
                if (input.len < 2) {
                    try stdout.writeAll("Invalid input. Give two indexes. Example: 11\n");
                    continue;
                }
                index1 = input[1];
                index2 = input[0];

                if ((index1 == 'q' or index1 == 'Q') and (index2 == 'q' or index2 == 'Q')) {
                    return;
                }

                if (index1 > 51 or index2 > 51 or index1 < 49 or index2 < 49) {
                    try stdout.writeAll("Invalid input. Invalid indexes.\n");
                    continue;
                }

                index1 -= 49;
                index2 -= 49;

                if (tiles[index1][index2] != ' ') {
                    try stdout.writeAll("Invalid input. Cannot place there.\n");
                    continue;
                }

                break;
            }

            tiles[index1][index2] = 'X';
        }

        if (player_turn) {
            player_turn = false;
        } else {
            player_turn = true;
        }

        turn += 1;

        if (checkForWinner(&tiles, 'O')) {
            try printBoard(&tiles, &stdout);
            try stdout.writeAll("player 1 wins!");
            std.time.sleep(5000000000);
            for (tiles, 0..) |row, i| {
                for (row, 0..) |_, j| {
                    tiles[i][j] = ' ';
                }
            }
            turn = 0;
        } else if (checkForWinner(&tiles, 'X')) {
            try printBoard(&tiles, &stdout);
            try stdout.writeAll("player 2 wins!");
            std.time.sleep(5000000000);
            for (tiles, 0..) |row, i| {
                for (row, 0..) |_, j| {
                    tiles[i][j] = ' ';
                }
            }
            turn = 0;
        }

        if (turn == 9) {
            try printBoard(&tiles, &stdout);
            try stdout.writeAll("It's a draw!");
            std.time.sleep(5000000000);
            for (tiles, 0..) |row, i| {
                for (row, 0..) |_, j| {
                    tiles[i][j] = ' ';
                }
            }
            turn = 0;
        }
    }
}
