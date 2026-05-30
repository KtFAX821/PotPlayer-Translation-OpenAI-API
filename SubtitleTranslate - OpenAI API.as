/*
	real time subtitle translate for PotPlayer using OpenAI API
	GitHub: https://github.com/Fung-2025/potplayer-translation-openaiapi
	OpenAI API Docs: https://platform.openai.com/docs/api-reference
*/

// void OnInitialize()
// void OnFinalize()
// string GetTitle() 											-> get title for UI
// string GetVersion()											-> get version for manage
// string GetDesc()												-> get detail information
// string GetLoginTitle()										-> get title for login dialog
// string GetLoginDesc()										-> get desc for login dialog
// string GetUserText()											-> get user text for login dialog
// string GetPasswordText()										-> get password text for login dialog
// string ServerLogin(string User, string Pass)							-> login
// string ServerLogout()										-> logout
//------------------------------------------------------------------------------------------------
// array<string> GetSrcLangs() 										-> get source language
// array<string> GetDstLangs() 										-> get target language
// string Translate(string Text, string &in SrcLang, string &in DstLang) 	-> do translate !!

array<string> LangTable = 
{
	"af",
	"sq",
	"am",
	"ar",
	"hy",
	"az",
	"eu",
	"be",
	"bn",
	"bs",
	"bg",
	"my",
	"ca",
	"ceb",
	"ny",
	"zh",
	"zh-CN",
	"zh-TW",
	"co",
	"hr",
	"cs",
	"da",
	"nl",
	"en",
	"eo",
	"et",
	"tl",
	"fi",
	"fr",
	"fy",
	"gl",
	"ka",
	"de",
	"el",
	"gu",
	"ht",
	"ha",
	"haw",
	"iw",
	"hi",
	"hmn",
	"hu",
	"is",
	"ig",
	"id",
	"ga",
	"it",
	"ja",
	"jw",
	"kn",
	"kk",
	"km",
	"ko",
	"ku",
	"ky",
	"lo",
	"la",
	"lv",
	"lt",
	"lb",
	"mk",
	"ms",
	"mg",
	"ml",
	"mt",
	"mi",
	"mr",
	"mn",
	"my",
	"ne",
	"no",
	"ps",
	"fa",
	"pl",
	"pt",
	"pa",
	"ro",
	"romanji",
	"ru",
	"sm",
	"gd",
	"sr",
	"st",
	"sn",
	"sd",
	"si",
	"sk",
	"sl",
	"so",
	"es",
	"su",
	"sw",
	"sv",
	"tg",
	"ta",
	"te",
	"th",
	"tr",
	"uk",
	"ur",
	"uz",
	"vi",
	"cy",
	"xh",
	"yi",
	"yo",
	"zu"
};

string UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36";

string GetTitle()
{
	return "{$CP949=OpenAI API$}{$CP950=OpenAI API$}{$CP0=OpenAI API$}";
}

string GetVersion()
{
	return "1";
}

string GetDesc()
{
	return "<a href=\"https://platform.openai.com/docs/api-reference\">https://platform.openai.com/docs/api-reference</a>";
}

string GetLoginTitle()
{
	return "Input OpenAI Model & API Settings";
}

string GetLoginDesc()
{
	return "Input model|api_url and API key";
}

string GetUserText()
{
	return "Model|API URL:";
}

string GetPasswordText()
{
	return "API Key:";
}

string model;
string api_url;
string api_key;

void OnInitialize()
{
	HostPrintUTF8("OpenAI API: Plugin loaded.\n");
	model = HostLoadString("openai_model", "");
	api_url = HostLoadString("openai_api_url", "");
	api_key = HostLoadString("openai_api_key", "");
	if (!api_key.empty()) {
		HostPrintUTF8("OpenAI API: Saved settings loaded.\n");
	} else {
		HostPrintUTF8("OpenAI API: No saved settings found. Please configure in settings menu.\n");
	}
}

void OnFinalize()
{
	HostPrintUTF8("OpenAI API: Plugin unloaded.\n");
}

array<string> split(string str, string delimiter)
{
	array<string> parts;
	int startPos = 0;
	while (true) {
		int index = str.findFirst(delimiter, startPos);
		if (index == -1) {
			parts.insertLast(str.substr(startPos));
			break;
		}
		else {
			parts.insertLast(str.substr(startPos, index - startPos));
			startPos = index + delimiter.length();
		}
	}
	return parts;
}

string ServerLogin(string User, string Pass)
{
	array<string> settings = split(User, "|");
	if (settings.length() != 2) return "fail: invalid model|api_url format";

	model = settings[0].Trim();
	api_url = settings[1].Trim();
	api_key = Pass.Trim();

	if (model.empty() || api_url.empty() || api_key.empty()) return "fail";

	HostSaveString("openai_model", model);
	HostSaveString("openai_api_url", api_url);
	HostSaveString("openai_api_key", api_key);
	HostPrintUTF8("OpenAI API: Settings saved.\n");
	return "200 ok";
}

void ServerLogout()
{
	api_key = "";
	HostSaveString("openai_api_key", "");
}

array<string> GetSrcLangs()
{
	array<string> ret = LangTable;
	
	ret.insertAt(0, ""); // empty is auto
	return ret;
}

array<string> GetDstLangs()
{
	array<string> ret = LangTable;
	return ret;
}

string Translate(string Text, string &in SrcLang, string &in DstLang)
{
	if (api_key.empty()) return "Error: API key not set";
	if (Text.empty()) return "";
	
	// 构建请求URL和头部
	string url = api_url;
	if (url.findFirst("/chat/completions") == -1) {
		if (url.substr(url.length() - 1, 1) == "/") {
			url += "chat/completions";
		} else {
			url += "/chat/completions";
		}
	}
	string SendHeader = "Authorization: Bearer " + api_key + "\n";
	SendHeader += "Content-Type: application/json";
	
	// 构建提示词和文本
	string prompt = "";
	if (SrcLang != "auto" && SrcLang != "") {
		prompt = "Translate the following text from " + SrcLang + " to " + DstLang + ": ";
	} else {
		prompt = "Translate the following text to " + DstLang + ": ";
	}
	
	// 构建请求体
	string escapedText = Text;
	// 处理基本转义字符
	escapedText.replace("\\", "\\\\");
	escapedText.replace("\"", "\\\"");
	escapedText.replace("\n", "\\n");
	escapedText.replace("\r", "\\r");
	escapedText.replace("\t", "\\t");
	
	// 处理Unicode控制字符 (0x00-0x1F)
	for (int i = 0; i < 0x20; i++) {
		string hex = formatInt(i, "%04X");
		string ctrl;
		ctrl.resize(1);
		ctrl[0] = uint8(i);
		escapedText.replace(ctrl, "\\u" + hex);
	}
	
	string Post = "{\"model\":\"" + model + "\",";
	Post += "\"messages\":[";
	Post += "{\"role\":\"system\",\"content\":\"You are a professional translator. You MUST translate the text ONLY to the specified target language. Your translation MUST be in the exact target language requested, not in any other language. Do not add any explanations or notes. Return only the translated text in the target language.\"},";
	Post += "{\"role\":\"user\",\"content\":\"" + prompt + escapedText + "\"}],";
	Post += "\"temperature\":0.5,";
	Post += "\"top_p\":0.9,";
	Post += "\"max_tokens\":1024}";
	// Post += "\"do_sample\":false}";
	
	// 发送请求
	string ret = "";
	HostPrintUTF8("OpenAI API: Requesting " + url + "\n");
	uintptr http = HostOpenHTTP(url, UserAgent, SendHeader, Post);
	if (http == 0) {
		HostPrintUTF8("OpenAI API: Failed to connect.\n");
		return "Error: Failed to connect to API";
	}
	if (http != 0)
	{
		string json = HostGetContentHTTP(http);
		HostPrintUTF8("OpenAI API: Response received.\n");
		JsonReader Reader;
		JsonValue Root;
	
		if (Reader.parse(json, Root) && Root.isObject())
		{
			JsonValue choices = Root["choices"];
			
			if (choices.isArray() && choices.size() > 0)
			{
				JsonValue message = choices[0]["message"];
				if (message.isObject())
				{
					JsonValue content = message["content"];
					if (content.isString())
					{
						ret = content.asString();
					}
				}
			}
			else
			{
				JsonValue error = Root["error"];
				if (error.isObject())
				{
					JsonValue message = error["message"];
					if (message.isString())
					{
						ret = "Error: " + message.asString();
					}
				}
			}
		}

		HostCloseHTTP(http);
	}
	
	SrcLang = "UTF8";
	DstLang = "UTF8";
	return ret;
}
