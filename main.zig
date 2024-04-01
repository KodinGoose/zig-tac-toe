const std = @import("std");

var player_1_turn = true;
var index1: u8 = undefined;
var index2: u8 = undefined;
var input: []u8 = undefined;
var turn_count: u4 = 0;
var tiles = [3][3]u8{
    [_]u8{ ' ', ' ', ' ' },
    [_]u8{ ' ', ' ', ' ' },
    [_]u8{ ' ', ' ', ' ' },
};

/// This is one byte bigger than it needs to be due to having to be compatible with windows
/// This does force an extra check to keep compatibility with literaly everything else
var buffer: [4]u8 = undefined;

fn checkForWinner(symbol: u8) bool {
    if (tiles[0][0] == symbol and tiles[0][1] == symbol and tiles[0][2] == symbol) {
        return true;
    } else if (tiles[1][0] == symbol and tiles[1][1] == symbol and tiles[1][2] == symbol) {
        return true;
    } else if (tiles[2][0] == symbol and tiles[2][1] == symbol and tiles[2][2] == symbol) {
        return true;
    } else if (tiles[0][0] == symbol and tiles[1][0] == symbol and tiles[2][0] == symbol) {
        return true;
    } else if (tiles[0][1] == symbol and tiles[1][1] == symbol and tiles[2][1] == symbol) {
        return true;
    } else if (tiles[0][2] == symbol and tiles[1][2] == symbol and tiles[2][2] == symbol) {
        return true;
    } else if (tiles[0][0] == symbol and tiles[1][1] == symbol and tiles[2][2] == symbol) {
        return true;
    } else if (tiles[0][2] == symbol and tiles[1][1] == symbol and tiles[2][0] == symbol) {
        return true;
    } else {
        return false;
    }
}

fn printBoard(stdout: anytype) !void {
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

    // main loop
    while (true) {
        try printBoard(&stdout);

        if (player_1_turn) {
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
                } else if (input.len > 2 and std.builtin.subsystem == null) {
                    // std.builtin.subsystem returns null when not running on windows
                    try stdout.writeAll("Invalid input. Give two indexes. Example: 11\n");
                    continue;
                }
                index1 = input[1];
                index2 = input[0];

                if ((index1 == 'q' or index1 == 'Q') and (index2 == 'q' or index2 == 'Q')) {
                    return;
                }

                if (index1 > '3' or index2 > '3' or index1 < '1' or index2 < '1') {
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
                } else if (input.len > 2 and std.builtin.subsystem == null) {
                    // std.builtin.subsystem returns null when not running on windows
                    try stdout.writeAll("Invalid input. Give two indexes. Example: 11\n");
                    continue;
                }
                index1 = input[1];
                index2 = input[0];

                if ((index1 == 'q' or index1 == 'Q') and (index2 == 'q' or index2 == 'Q')) {
                    return;
                }

                if (index1 > '3' or index2 > '3' or index1 < '1' or index2 < '1') {
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

        if (player_1_turn) {
            player_1_turn = false;
        } else {
            player_1_turn = true;
        }

        turn_count += 1;

        if (checkForWinner('O')) {
            try printBoard(&stdout);
            try stdout.writeAll("player 1 wins!");
            std.time.sleep(5000000000);
            for (tiles, 0..) |row, i| {
                for (row, 0..) |_, j| {
                    tiles[i][j] = ' ';
                }
            }
            turn_count = 0;
        } else if (checkForWinner('X')) {
            try printBoard(&stdout);
            try stdout.writeAll("player 2 wins!");
            std.time.sleep(5000000000);
            for (tiles, 0..) |row, i| {
                for (row, 0..) |_, j| {
                    tiles[i][j] = ' ';
                }
            }
            turn_count = 0;
        }

        if (turn_count == 9) {
            try printBoard(&stdout);
            try stdout.writeAll("It's a draw!");
            std.time.sleep(5000000000);
            for (tiles, 0..) |row, i| {
                for (row, 0..) |_, j| {
                    tiles[i][j] = ' ';
                }
            }
            turn_count = 0;
        }
    }
}
