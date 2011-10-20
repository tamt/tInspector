/**
 * Copyright jozefchutka ( http://wonderfl.net/user/jozefchutka )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/fY34
 */
package cn.itamt.data.parser
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	[SWF(width="465", height="465", frameRate="30", backgroundColor="#ffffff")]
	public class WonderflApp extends Sprite
	{
		private var textField : TextField = new TextField();

		public function WonderflApp() : void
		{
			var request : URLRequest = new URLRequest("http://blog.yoz.sk/wp-content/themes/dark/style.css");
			var loader : URLLoader = new URLLoader;
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, onComplete);

			textField.width = stage.stageWidth;
			textField.height = stage.stageHeight;
			textField.wordWrap = true;
			textField.multiline = true;
			textField.defaultTextFormat = new TextFormat(null, 13);
			addChild(textField);
		}

		private function onComplete(event : Event) : void
		{
			var d0 : Date = new Date;
			var highlighter : CSSHighliter = new CSSHighliter;
			var source : String = URLLoader(event.currentTarget).data as String;
			var html : String = highlighter.highlight(source);
			var time : Number = new Date().time - d0.time;
			var stat : String = "length: " + Math.round(source.length / 1024) + "Kb, " + "time:" + time.toString() + "ms, " + "speed: " + Math.round((source.length / 1024) / (time / 1000)) + "Kbps\n";

			textField.htmlText = stat + html;
		}
	}
}
class CSSHighliter
{
	private var formatted : String = "";

	public function highlight(input : String) : String
	{
		formatted = "";

		var parser : CSSSequenceParser = new CSSSequenceParser;
		parser.suggestSequences(generalCallback, importStart, importEnd, selectorMatch, definitionStart, definitionEnd, attributeCallback, urlStart, urlEnd, valueMatch, commentStart, commentEnd, quoteStart, quoteEnd);
		parser.parse(input);

		return formatted;
	}

	private function importStart(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<font color='#0000ff'>" + value + "</font>";
	}

	private function importEnd(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += value;
	}

	private function definitionStart(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<font color='#aaaaaa'>" + value + "</font>";
	}

	private function definitionEnd(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<font color='#aaaaaa'>" + value + "</font>";
	}

	private function attributeCallback(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<font color='#0000ff'>" + value + "</font>";
	}

	private function urlStart(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<font color='#0000ff'>" + value + "</font><font color='#ff0000'>";
	}

	private function urlEnd(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "</font>" + value;
	}

	private function commentStart(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<font color='#00ff00'>" + value;
	}

	private function commentEnd(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += value + "</font>";
	}

	private function quoteStart(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<font color='#ff00ff'><b>" + value;
	}

	private function quoteEnd(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += value + "</b></font>";
	}

	private function selectorMatch(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<b>" + value + "</b>";
	}

	private function valueMatch(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += "<font color='#ff0000'>" + value + "</font>";
	}

	private function generalCallback(value : String) : void
	{
		value = optimizeForHTMLTextField(value);
		formatted += value;
	}

	private function optimizeForHTMLTextField(input : String) : String
	{
		return input.replace("\n", "")
			.replace("<", "&lt;").replace(">", "&gt;");
		;
	}
}
class CSSSequenceParser
{
	private var sequences : Vector.<ISequence> = new Vector.<ISequence>;

	public function suggestSequences(generalCallback : Function, importStart : Function, importEnd : Function, selectorMatch : Function, definitionStart : Function, definitionEnd : Function, attributeCallback : Function, urlStart : Function, urlEnd : Function, valueMatch : Function, commentStart : Function, commentEnd : Function, quoteStart : Function, quoteEnd : Function) : void
	{
		var definitionSequences : Vector.<ISequence> = new Vector.<ISequence>;
		var importSequences : Vector.<ISequence> = new Vector.<ISequence>;
		var urlSequences : Vector.<ISequence> = new Vector.<ISequence>;
		var commentSequences : Vector.<ISequence> = new Vector.<ISequence>;
		var quoteSequences : Vector.<ISequence> = new Vector.<ISequence>;

		var sequenceAny : ISequence = new MatchAnythingSequence(false, generalCallback);
		var sequenceSpaces : ISequence = new MatchRegexpSequence(/^[\s]+/, false, generalCallback);
		var sequenceSelector : ISequence = new MatchRegexpSequence(/^[^\,\{\/]+/i, false, selectorMatch);
		var sequenceDefinition : ISequence = new StartStringEndStringSequence("{", "}", definitionSequences, false, definitionStart, definitionEnd);
		var sequenceAttribute : ISequence = new MatchRegexpSequence(/^[a-z\-]+[\s]*(?:\:)/i, false, attributeCallback);
		var sequenceValue : ISequence = new MatchRegexpSequence(/^[^\:\;\s\}]+/, false, valueMatch);
		var sequenceImport : ISequence = new StartRegexpEndStringSequence(/^\@import/i, ";", importSequences, false, importStart, importEnd);
		var sequenceURL : ISequence = new StartRegexpEndStringSequence(/^url\(/i, ")", urlSequences, false, urlStart, urlEnd);
		var sequenceComment : ISequence = new StartStringEndStringSequence("/*", "*/", commentSequences, false, commentStart, commentEnd);
		var sequenceQuote : ISequence = new StartStringEndStringSequence('"', '"', quoteSequences, false, quoteStart, quoteEnd);
		var sequenceQuote2 : ISequence = new StartStringEndStringSequence("'", "'", quoteSequences, false, quoteStart, quoteEnd);

		definitionSequences.push(sequenceComment);
		definitionSequences.push(sequenceAttribute);
		definitionSequences.push(sequenceURL);
		definitionSequences.push(sequenceQuote);
		definitionSequences.push(sequenceQuote2);
		definitionSequences.push(sequenceValue);
		definitionSequences.push(sequenceSpaces);
		definitionSequences.push(sequenceAny);

		importSequences.push(sequenceComment);
		importSequences.push(sequenceURL);
		importSequences.push(sequenceQuote);
		importSequences.push(sequenceQuote2);
		importSequences.push(sequenceAny);

		urlSequences.push(sequenceComment);
		urlSequences.push(sequenceQuote);
		urlSequences.push(sequenceQuote2);
		urlSequences.push(sequenceSpaces);
		urlSequences.push(sequenceAny);

		commentSequences.push(sequenceAny);

		quoteSequences.push(sequenceAny);

		sequences = new Vector.<ISequence>;
		sequences.push(sequenceComment);
		sequences.push(sequenceImport);
		sequences.push(sequenceSelector);
		sequences.push(sequenceDefinition);
		sequences.push(sequenceSpaces);
		sequences.push(sequenceAny);
	}

	public function parse(input : String) : String
	{
		return SequenceParser.parse(input, sequences);
	}
}
class SequenceParser
{
	public static function parse(input : String, sequences : Vector.<ISequence>) : String
	{
		if (input == null || !input.length || !sequences || !sequences.length)
			return input;

		var source : String = input;
		var i : uint = 0;
		while (true)
		{
			var sequence : ISequence = sequences[i++];
			var match : String = sequence.test(source);
			if (match != null)
			{
				source = source.substr(match.length);
				source = parse(source, sequence.sequences);
				if (sequence.stopSequence)
					break;
				i = 0;
			}
			else if (i == sequences.length)
				break;
		}

		if (source == input)
			throw new Error("Unmatching sequences");
		return source;
	}
}
interface ISequence
{
	function test(input : String) : String

	function get sequences() : Vector.<ISequence>

	function get stopSequence() : Boolean
}
class MatchAnythingSequence implements ISequence
{
	private var _stopSequence : Boolean;
	private var matchCallback : Function;

	public function MatchAnythingSequence(stopSequence : Boolean = false, matchCallback : Function = null)
	{
		_stopSequence = stopSequence;
		this.matchCallback = matchCallback;
	}

	public function test(input : String) : String
	{
		if (input == null || !input.length)
			return null;

		var match : String = input.substr(0, 1);
		if (matchCallback != null)
			matchCallback(match);
		return match;
	}

	public function get sequences() : Vector.<ISequence>
	{
		return null;
	}

	public function get stopSequence() : Boolean
	{
		return _stopSequence;
	}
}
class MatchRegexpSequence implements ISequence
{
	private var match : RegExp;
	private var _stopSequence : Boolean;
	private var matchCallback : Function;

	public function MatchRegexpSequence(match : RegExp, stopSequence : Boolean = false, matchCallback : Function = null)
	{
		this.match = match;
		_stopSequence = stopSequence;
		this.matchCallback = matchCallback;
	}

	public function test(input : String) : String
	{
		var matches : Array = input.match(this.match);
		if (matches)
		{
			var match : String = matches[0];
			if (matchCallback != null)
				matchCallback(match);
			return match;
		}
		return null;
	}

	public function get sequences() : Vector.<ISequence>
	{
		return null;
	}

	public function get stopSequence() : Boolean
	{
		return _stopSequence;
	}
}
class MatchStringSequence implements ISequence
{
	private var match : String;
	private var _stopSequence : Boolean;
	private var matchCallback : Function;

	public function MatchStringSequence(match : String, stopSequence : Boolean = false, matchCallback : Function = null)
	{
		this.match = match;
		_stopSequence = stopSequence;
		this.matchCallback = matchCallback;
	}

	public function test(input : String) : String
	{
		if (input.substr(0, match.length) == match)
		{
			if (matchCallback != null)
				matchCallback(match);
			return match;
		}
		return null;
	}

	public function get sequences() : Vector.<ISequence>
	{
		return null;
	}

	public function get stopSequence() : Boolean
	{
		return _stopSequence;
	}
}
class StartRegexpEndStringSequence implements ISequence
{
	private var startSequence : MatchRegexpSequence;
	private var endSequence : MatchStringSequence;
	private var _sequences : Vector.<ISequence>;
	private var _stopSequence : Boolean;

	public function StartRegexpEndStringSequence(start : RegExp, end : String, sequences : Vector.<ISequence> = null, stopSequence : Boolean = false, startCallback : Function = null, endCallback : Function = null)
	{
		startSequence = new MatchRegexpSequence(start, false, startCallback);
		endSequence = new MatchStringSequence(end, true, endCallback);
		_sequences = sequences;
		_stopSequence = stopSequence;
	}

	public function get sequences() : Vector.<ISequence>
	{
		var result : Vector.<ISequence> = _sequences ? _sequences.concat() : new Vector.<ISequence>;
		result.splice(0, 0, endSequence);
		return result;
	}

	public function test(input : String) : String
	{
		return startSequence.test(input);
	}

	public function get stopSequence() : Boolean
	{
		return _stopSequence;
	}
}
class StartStringEndStringSequence implements ISequence
{
	private var startSequence : MatchStringSequence;
	private var endSequence : MatchStringSequence;
	private var _sequences : Vector.<ISequence>;
	private var _stopSequence : Boolean;

	public function StartStringEndStringSequence(start : String, end : String, sequences : Vector.<ISequence> = null, stopSequence : Boolean = false, startCallback : Function = null, endCallback : Function = null)
	{
		startSequence = new MatchStringSequence(start, false, startCallback);
		endSequence = new MatchStringSequence(end, true, endCallback);
		_sequences = sequences;
		_stopSequence = stopSequence;
	}

	public function get sequences() : Vector.<ISequence>
	{
		var result : Vector.<ISequence> = _sequences ? _sequences.concat() : new Vector.<ISequence>;
		result.splice(0, 0, endSequence);
		return result;
	}

	public function test(input : String) : String
	{
		return startSequence.test(input);
	}

	public function get stopSequence() : Boolean
	{
		return _stopSequence;
	}
}