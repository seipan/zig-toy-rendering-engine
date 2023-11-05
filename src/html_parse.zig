const std = @import("std");

const Parser = struct {
    /// The number of seconds since the epoch (this is also a doc comment).
    pos: i64, // signed so we can represent pre-1970 (not a doc comment)
    /// The number of nanoseconds past the second (doc comment again).
    input: []u8,

    pub fn init(input: []const u8) Parser {
        return Parser{
            .pos = 0,
            .input = input,
        };
    }

    pub fn nextChar(self: *Parser) ?u8 {
        if (self.pos >= self.input.len) return null;
        const result = self.input[self.pos];
        self.pos += 1;
        return result;
    }

    pub fn startWith(self: *Parser, prefix: []const u8) bool {
        std.startsWith(u8, self.input[self.pos], prefix);
    }

    pub fn eof(self: *Parser) bool {
        return self.pos >= self.input.len;
    }

    pub fn consumeChar(self: *Parser) ?u8 {
        if (self.pos >= self.input.len) return null;

        const nextCodePoint = std.unicode.utf8Decode(self.input[self.pos..]);
        const char = nextCodePoint[0];
        const charLen = std.unicode.utf8ByteSequenceLength(self.input[self.pos]);

        self.pos += charLen;
        return char;
    }
};
