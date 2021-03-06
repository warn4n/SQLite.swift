//
// SQLite.swift
// https://github.com/stephencelis/SQLite.swift
// Copyright (c) 2014-2015 Stephen Celis.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

public func fts4(columns: Expression<String>...) -> Expression<()> {
    return fts4(columns)
}

// TODO: matchinfo, compress, uncompress
public func fts4(columns: [Expression<String>], tokenize tokenizer: Tokenizer? = nil) -> Expression<()> {
    var options = [String: String]()
    options["tokenize"] = tokenizer?.rawValue
    return fts("fts4", columns, options)
}

private func fts(function: String, columns: [Expression<String>], options: [String: String]) -> Expression<()> {
    var definitions: [Expressible] = columns.map { $0.expression }
    for (key, value) in options {
        definitions.append(Expression<()>(literal: "\(key)=\(value)"))
    }
    return wrap(function, Expression<()>.join(", ", definitions))
}

public enum Tokenizer: String {

    case Simple = "simple"

    case Porter = "porter"

}

public func match(string: String, expression: Query) -> Expression<Bool> {
    return infix("MATCH", Expression<String>(expression.tableName), Expression<String>(binding: string))
}
