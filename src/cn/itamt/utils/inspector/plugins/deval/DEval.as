package cn.itamt.utils.inspector.plugins.deval
{
	import r1.deval.D;

	import utility.CharacterEntity;

	import flash.display.DisplayObject;

	/**
	 * DEval插件，在as3中实现eval方法。可以动态运行代码。
	 * @author tamt
	 * @seehttp://www.riaone.com/products/deval/
	 */
	public class DEval extends Object
	{

		/**
		* @param receiverThe Function that will handel the D.eval output
		* @param scopeThe AS3 Scope(this)
		*/
		private var errMsgList:Array;
		public function DEval(receiver:Function)
		{
			super();
			errMsgList = new Array();
			/* rt error messages */
			errMsgList["msg.rt.no.class"] = "You must import the class before being able to instantiate it. Ex. import flash.display.MovieClip;";
			errMsgList["msg.rt.no.function"] = "You must import the Function before being able to call it.";
			errMsgList["msg.rt.no.method"] = "Call to a possibly undefined method.";
			/* parser messages */
			errMsgList["msg.no.paren.parms"] = "missing ( before function parameters";
			errMsgList["msg.no.parm"] = "missing formal parameter";
			errMsgList["msg.no.paren.after.parms"] = "missing ) after formal parameters";
			errMsgList["msg.no.brace.body"] = "missing '{' before function body";
			errMsgList["msg.no.brace.after.body"] = "missing } after function body";
			errMsgList["msg.no.paren.cond"] = "missing ( before condition";
			errMsgList["msg.no.paren.after.cond"] = "missing ) after condition";
			errMsgList["msg.no.semi.stmt"] = "missing ; before statement";
			errMsgList["msg.no.name.after.dot"] = "missing name after . operator";
			errMsgList["msg.no.bracket.index"] = "missing ] in index expression";
			errMsgList["msg.no.paren.switch"] = "missing ( before switch expression";
			errMsgList["msg.no.paren.after.switch"] = "missing ) after switch expression";
			errMsgList["msg.no.brace.switch"] = "missing '{' before switch body";
			errMsgList["msg.bad.switch"] = "invalid switch statement";
			errMsgList["msg.no.colon.case"] = "missing : after case expression";
			errMsgList["msg.no.while.do"] = "missing while after do-loop body";
			errMsgList["msg.no.paren.for"] = "missing ( after for";
			errMsgList["msg.no.semi.for"] = "missing ; after for-loop initializer";
			errMsgList["msg.no.semi.for.cond"] = "missing ; after for-loop condition";
			errMsgList["msg.no.paren.for.ctrl"] = "missing ) after for-loop control";
			errMsgList["msg.no.paren.with"] = "missing ( before with-statement object";
			errMsgList["msg.no.paren.after.with"] = "missing ) after with-statement object";
			errMsgList["msg.bad.return"] = "invalid return";
			errMsgList["msg.no.brace.block"] = "missing } in compound statement";
			errMsgList["msg.bad.label"] = "invalid label";
			errMsgList["msg.bad.var"] = "missing variable name";
			errMsgList["msg.bad.var.init"] = "invalid variable initialization";
			errMsgList["msg.no.colon.cond"] = "missing : in conditional expression";
			errMsgList["msg.no.paren.arg"] = "missing ) after argument list";
			errMsgList["msg.no.bracket.arg"] = "missing ] after element list";
			errMsgList["msg.bad.prop"] = "invalid property id";
			errMsgList["msg.no.colon.prop"] = "missing : after property id";
			errMsgList["msg.no.brace.prop"] = "missing } after property list";
			errMsgList["msg.no.paren"] = "missing ) in parenthetical";
			errMsgList["msg.reserved.id"] = "identifier is a reserved word";
			errMsgList["msg.no.paren.catch"] = "missing ( before catch-block condition";
			errMsgList["msg.bad.catchcond"] = "invalid catch block condition";
			errMsgList["msg.catch.unreachable"] = "any catch clauses following an unqualified catch are unreachable";
			errMsgList["msg.no.brace.catchblock"] = "missing '{' before catch-block body";
			errMsgList["msg.try.no.catchfinally"] = "''try'' without ''catch'' or ''finally''";
			errMsgList["msg.syntax"] = "syntax error";
			errMsgList["mag.too.deep.parser.recursion"] = "Too deep recursion while parsing";

			setOutputReceiver(receiver);
		}

		//自动链接this，把eval中的this链接到当前查看的对象，这样代码中的this会引用当前查看的对象
		protected var _this:DisplayObject = null;

		protected var outputReceiver:Function = null;

		/**
		 * set D.eval's output receiver.
		 */
		public function setOutputReceiver(receiver:Function):void
		{
			outputReceiver = receiver;
			D.setOutput(outputReceiver);
		}

		/**
		 * run eval code.
		 */
		public function runCode(code:String,_this):void
		{
			if (_this)
			{
				//D.eval内部直接访问对象的prototype属性，会导致运行出错。这个用于修正这个错误。
				_this["constructor"].prototype.prototype = null;
			}
			code = CharacterEntity.decode(code);
			code = code.replace(/trace/g,'printf');// we need always to return values
			try
			{
				D.eval(code, null, _this);
			}
			catch (e:Error)
			{
				var errMsg:String = e.message.toString();
				if (errMsgList[errMsg]) errMsg = errMsgList[errMsg]; // get message from array if its exist
				if (errMsg.indexOf("Error") < 0) errMsg = "Error: " + errMsg;
				outputReceiver(errMsg);
			}
		}
	}
}