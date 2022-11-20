#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("ИмяПредопределенныхДанных");
	Результат.Добавить("Код");
	Результат.Добавить("ПометкаУдаления");
	
	Возврат Результат;
	
КонецФункции

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ЗаполнитьКодыВычетовНДФЛ();
	
КонецПроцедуры

Процедура ЗаполнитьКодыВычетовНДФЛ() Экспорт
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	ВычетыНДФЛ = Справочники.ВычетыНДФЛ;
	ГруппыВычетов = Перечисления.ГруппыВычетовПоНДФЛ;
	
	ОписатьКодВычетаНДФЛ("Код103", "103", "400 руб. на налогоплательщика, не относящегося к категориям, перечисленным в пп. 1-2 п. 1 ст. 218 Налогового кодекса Российской Федерации", Ложь, ГруппыВычетов.Стандартные,
		"103","-", "-");
	ОписатьКодВычетаНДФЛ("Код104", "104", "500 рублей на налогоплательщика, относящегося к категориям, перечисленным в пп. 2 п. 1 ст. 218 Налогового кодекса Российской Федерации", Ложь, ГруппыВычетов.Стандартные,
		"104","104","104");
	ОписатьКодВычетаНДФЛ("Код105", "105", "3000 рублей на налогоплательщика, относящегося к категориям, перечисленным в пп. 1 п. 1 ст. 218 Налогового кодекса Российской Федерации", Ложь, ГруппыВычетов.Стандартные,
		"105","105","105");
	ОписатьКодВычетаНДФЛ("Код108", "126/114", "На первого ребенка в возрасте до 18 лет, на учащегося очной формы обучения, аспиранта, ординатора, студента, курсанта в возрасте до 24 лет", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"114", "114", "126");
	ОписатьКодВычетаНДФЛ("Код109", "129/117", "На ребенка-инвалида до 18 лет, на учащегося очной формы обучения, аспиранта, ординатора, студента до 24 лет, явл. инвалидом I или II группы", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"117", "117", "129");
	ОписатьКодВычетаНДФЛ("Код110", "134/118", "В двойном размере на первого ребенка до 18 лет, на учащегося очной формы обучения до 24 лет единственному родителю, опекуну, попечителю", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"118", "118", "134");
	ОписатьКодВычетаНДФЛ("Код111", "142/122", "В двойном размере на первого ребенка до 18 лет, на учащегося очной формы обучения до 24 лет при отказе второго родителя от вычета", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"122", "122", "142");
	ОписатьКодВычетаНДФЛ("Код112", "140/121", "В двойном размере на ребенка-инвалида до 18 лет, на учащегося очной формы обучения до 24 лет, явл. инвалидом, единственному родителю, опекуну и др.", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"121", "121", "140");
	ОписатьКодВычетаНДФЛ("Код113", "148/125", "В двойном размере на ребенка-инвалида до 18 лет, на учащегося очной формы обучения до 24 лет, явл. инвалидом, при отказе второго родителя от вычета", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"125", "125", "148");
	ОписатьКодВычетаНДФЛ("Код115", "127/115", "На второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, студента, курсанта в возрасте до 24", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"115", "115", "127");
	ОписатьКодВычетаНДФЛ("Код116", "128/116", "На третьего и каждого последующего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, студента, к", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"116", "116", "128");
	ОписатьКодВычетаНДФЛ("Код119", "136/119", "В двойном размере на второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, студента, курсант", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"119", "119", "136");
	ОписатьКодВычетаНДФЛ("Код120", "138/120", "В двойном размере на третьего и каждого последующего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ордин", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"120", "120", "138");
	ОписатьКодВычетаНДФЛ("Код123", "144/123", "В двойном размере на второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, студента, курсант", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"123", "123", "144");
	ОписатьКодВычетаНДФЛ("Код124", "146/124", "В двойном размере на третьего и каждого последующего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ордин", Ложь, ГруппыВычетов.СтандартныеНаДетей,
		"124", "124", "146");
	
	ОписатьКодВычетаНДФЛ("Код130", "130", "На первого ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет опекуну, попечителю, приемному родителю, супруге (супругу) приемного родителя, на обеспечении которых находится ребенок", 
	Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"114", "114", "130");
	ОписатьКодВычетаНДФЛ("Код131", "131", "На второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет опекуну, попечителю, приемному родителю, супруге (супругу) приемного родителя, на обеспечении которых находится ребенок", 
		Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"115", "115", "131");
	ОписатьКодВычетаНДФЛ("Код132", "132", "На третьего и каждого последующего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет опекуну, попечителю, приемному родителю, супруге (супругу) приемного родителя, на обеспечении которых находится ребенок", 
		Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"116", "116", "132");
	ОписатьКодВычетаНДФЛ("Код135", "135", "В двойном размере на первого ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет единственному опекуну, попечителю, приемному родителю", 
		Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"118", "118", "135");
	ОписатьКодВычетаНДФЛ("Код137", "137", "В двойном размере на второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет единственному опекуну, попечителю, приемному родителю", 
		Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"119", "119", "137");
	ОписатьКодВычетаНДФЛ("Код139", "139", "В двойном размере на третьего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет единственному опекуну, попечителю, приемному родителю", 
		Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"120", "120", "139");
	ОписатьКодВычетаНДФЛ("Код143", "143", "В двойном размере на первого ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет одному из приемных родителей по их выбору на основании заявления об отказе одного из приемных родителей от получения налогового вычета", 
		Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"122", "122", "143");
	ОписатьКодВычетаНДФЛ("Код145", "145", "В двойном размере на второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет одному из приемных родителей по их выбору на основании заявления об отказе одного из приемных родителей от получения налогового вычета", 
		Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"123", "123", "145");
	ОписатьКодВычетаНДФЛ("Код147", "147", "В двойном размере на третьего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, интерна, студента, курсанта в возрасте до 24 лет одному из приемных родителей по их выбору на основании заявления об отказе одного из приемных родителей от получения налогового вычета", 
		Ложь, ГруппыВычетов.СтандартныеНаДетей, 
		"124", "124", "147");
	
	ОписатьКодВычетаНДФЛ("Код201", "201", "Расходы по операциям с ценными бумагами, обращающимися на организованном рынке ценных бумаг",
		"201","201","201");
	ОписатьКодВычетаНДФЛ("Код202", "202", "Расходы по операциям с ценными бумагами, не обращающимися на организованном рынке ценных бумаг",
		"202","202","202");
	ОписатьКодВычетаНДФЛ("Код203", "203", "Расходы по операциям с ценными бумагами, не обр-мися на орг.рынке ценных бумаг, которые на момент их приобретения обр-лись на орг.рынке ценных бумаг",
		"203","203","203");
	ОписатьКодВычетаНДФЛ("Код204", "204", "Убыток по опер-ям с цен.бумагами, не обр-ся на орг. рынке, которые на момент приобретения обр-сь на орг. рынке, уменьш. нал. базу доходов с кодом 1530",,,,"-", "-");
	ОписатьКодВычетаНДФЛ("Код205", "205", "Убыток по операциям с ценными бумагами, обращающимися на организованном рынке ценных бумаг, уменьшающий налоговую базу доходов с кодом 1532",
		"205","205","205");
	ОписатьКодВычетаНДФЛ("Код206", "206", "Расходы по доходам с кодом 1532",,,"206","206","206");
	ОписатьКодВычетаНДФЛ("Код207", "207", "Расходы по доходам с кодом 1535",,,"207","207","207");
	ОписатьКодВычетаНДФЛ("Код208", "208", "Убыток по опер. с фин.инстр. срочных сделок, обр-ся на орг. рынке, базисным активом которых явл. цен.бумаги, уменьш. нал. базу доходов с кодом 1530",,,,"-", "208");
	ОписатьКодВычетаНДФЛ("Код209", "209", "Убыток по опер. с фин.инстр. ср.сделок, обр-ся на орг.рынке, базисным активом кот. не явл. цен.бумаги,  уменьш. нал. базу по опер. с фин.инстр. ср.сд.",
		"209","209","209");
	
	ОписатьКодВычетаНДФЛ("Код226", "226", "Расходы по операциям с ценными бумагами, не обращающимися на организованном рынке ценных бумаг, учитываемым на индивидуальном инвестиционном счете",
		, , 
		"-","-","226"); 
	ОписатьКодВычетаНДФЛ("Код227", "227", "Расходы по операциям с ценными бумагами, не обращающимися на организованном рынке ценных бумаг, которые на момент их приобретения относились к ценным бумагам, обращающимся на организованном рынке ценных бумаг, учитываемым на индивидуальном инвестиционном счете",
		, , 
		"-","-","227"); 
	ОписатьКодВычетаНДФЛ("Код228", "228", "Расходы по операциям с производными финансовыми инструментами, которые обращаются на организованном рынке и базисным активом которых являются ценные бумаги, фондовые индексы или иные производные финансовые инструменты, базисным активом которых являются ценные бумаги или фондовые индексы, учитываемым на индивидуальном инвестиционном счете",
		, , 
		"-","-","228"); 
	ОписатьКодВычетаНДФЛ("Код229", "229", "Расходы по операциям с производными финансовыми инструментами, которые обращаются на организованном рынке и базисным активом которых не являются ценные бумаги, фондовые индексы или иные производные финансовые инструменты, базисным активом которых являются ценные бумаги или фондовые индексы, учитываемым на индивидуальном инвестиционном счете",
		, , 
		"-","-","229"); 
	ОписатьКодВычетаНДФЛ("Код230", "230", "Расходы в виде процентов по займу, произведенные по совокупности операций РЕПО, учитываемых на индивидуальном инвестиционном счете",
		, , 
		"-","-","230"); 
	ОписатьКодВычетаНДФЛ("Код231", "231", "Расходы по операциям, связанным с закрытием короткой позиции, и затраты, связанные с приобретением и реализацией ценных бумаг, являющимся объектом операций РЕПО, учитываемых на индивидуальном инвестиционном счете",
		, , 
		"-","-","231"); 
	ОписатьКодВычетаНДФЛ("Код232", "232", "Расходы в виде процентов, уплаченных в налоговом периоде по совокупности договоров займа, учитываемых на индивидуальном инвестиционном счете",
		, , 
		"-","-","232"); 
	ОписатьКодВычетаНДФЛ("Код233", "233", "Процентный (купонный) расход, признаваемый налогоплательщиком в случае открытия короткой позиции по ценным бумагам, обращающимся на организованном рынке ценных бумаг, по которым предусмотрено начисление процентного (купонного) дохода, учитываемый на индивидуальном инвестиционном счете",
		, , 
		"-","-","233"); 
	ОписатьКодВычетаНДФЛ("Код234", "234", "Процентный (купонный) расход, признаваемый налогоплательщиком в случае открытия короткой позиции по ценным бумагам, не обращающимся на организованном рынке ценных бумаг, по которым предусмотрено начисление процентного (купонного) дохода, учитываемый на индивидуальном инвестиционном счете",
		, , 
		"-","-","234"); 
	ОписатьКодВычетаНДФЛ("Код235", "235", "Суммы расходов по операциям с производными финансовыми инструментами, не обращающимися на организованном рынке, учитываемым на индивидуальном инвестиционном счете",
		, , 
		"-","-","235"); 
	ОписатьКодВычетаНДФЛ("Код236", "236", "Сумма отрицательного финансового результата, полученного в налоговом периоде по операциям с ценными бумагами, обращающимися на организованном рынке ценных бумаг, уменьшающая финансовый результат, полученный в налоговом периоде по отдельным операциям с ценными бумагами, не обращающимися на организованном рынке ценных бумаг, которые на момент их приобретения относились к ценным бумагам, обращающимся на организованном рынке ценных бумаг, учитываемая на индивидуальном инвестиционном счете",
		, , 
		"-","-","236"); 
	ОписатьКодВычетаНДФЛ("Код237", "237", "Сумма превышения расходов в виде процентов, уплаченных по совокупности договоров займа над доходами, полученными по совокупности договоров займа, уменьшающая налоговую базу по операциям с ценными бумагами, учитываемым на индивидуальном инвестиционном счете, обращающимися на организованном рынке ценных бумаг, рассчитанная в соответствии с пропорцией, с учетом положений абзаца шестого пункта 5 статьи 214.4 Налогового кодекса Российской Федерации",
		, , 
		"-","-","237"); 
	ОписатьКодВычетаНДФЛ("Код238", "238", "Сумма превышения расходов в виде процентов, уплаченных по совокупности договоров займа над доходами, полученными по совокупности договоров займа, уменьшающая налоговую базу по операциям с ценными бумагами, учитываемым на индивидуальном инвестиционном счете, не обращающимися на организованном рынке ценных бумаг, рассчитанная в соответствии с пропорцией, с учетом положений абзаца шестого пункта 5 статьи 214.4 Налогового кодекса Российской Федерации",
		, , 
		"-","-","238"); 
	ОписатьКодВычетаНДФЛ("Код239", "239", "Сумма убытка по операциям РЕПО, учитываемым на индивидуальном инвестиционном счете, принимаемого в уменьшение доходов по операциям с ценными бумагами, учитываемым на индивидуальном инвестиционном счете, обращающимися на организованном рынке ценных бумаг, в пропорции, рассчитанной как отношение стоимости ценных бумаг, являющихся объектом операций РЕПО, обращающихся на организованном рынке ценных бумаг, к общей стоимости ценных бумаг, являющихся объектом операций РЕПО",
		, , 
		"-","-","239"); 
	ОписатьКодВычетаНДФЛ("Код240", "240", "Сумма убытка по операциям РЕПО, учитываемым на индивидуальном инвестиционном счете, принимаемого в уменьшение доходов по операциям с ценными бумагами, учитываемым на индивидуальном инвестиционном счете, не обращающимися на организованном рынке ценных бумаг, в пропорции, рассчитанной как отношение стоимости ценных бумаг, являющихся объектом операций РЕПО, не обращающихся на организованном рынке ценных бумаг, к общей стоимости ценных бумаг, являющихся объектом операций РЕПО",
		, , 
		"-","-","240"); 
	ОписатьКодВычетаНДФЛ("Код241", "241", "Сумма убытка по операциям с производными финансовыми инструментами, обращающимися на организованном рынке, базисным активом которых являются ценные бумаги, фондовые индексы или иные производные финансовые инструменты, базисным активом которых являются ценные бумаги или фондовые индексы, полученного по результатам указанных операций, совершенных в налоговом периоде и учитываемых на индивидуальном инвестиционном счете, уменьшающего налоговую базу по операциям с производными финансовыми инструментами, которые обращаются на организованном рынке ценных бумаг, учитываемые на индивидуальном инвестиционном счете",
		, , 
		"-","-","241"); 
	ОписатьКодВычетаНДФЛ("Код250", "250", "Сумма убытка по операциям с ценными бумагами, обращающимися на организованном рынке ценных бумаг, полученного по результатам указанных операций, совершенных в налоговом периоде и учитываемых на индивидуальном инвестиционном счете, уменьшающая финансовый результат по операциям с производными финансовыми инструментами, обращающимися на организованном рынке, базисным активом которых являются ценные бумаги, фондовые индексы или иные производные финансовые инструменты, базисным активом которых являются ценные бумаги или фондовые индексы, учитываемым на индивидуальном инвестиционном счете",
		, , 
		"-","-","250"); 
	ОписатьКодВычетаНДФЛ("Код251", "251", "Сумма убытка по операциям с производными финансовыми инструментами, обращающимися на организованном рынке, базисным активом которых являются ценные бумаги, фондовые индексы или иные производные финансовые инструменты, базисным активом которых являются ценные бумаги или фондовые индексы, полученного по результатам указанных операций, совершенных в налоговом периоде и учитываемых на индивидуальном инвестиционном счете, после уменьшения финансового результата по операциям с производными финансовыми инструментами, обращающимися на организованном рынке, уменьшающая финансовый результат по операциям с ценными бумагами, обращающимися на организованном рынке ценных бумаг, учитываемым на индивидуальном инвестиционном счете",
		, , 
		"-","-","251"); 
	ОписатьКодВычетаНДФЛ("Код252", "252", "Сумма убытка по операциям с производными финансовыми инструментами, обращающимися на организованном рынке, базисным активом которых не являются ценные бумаги, фондовые индексы или иные производные финансовые инструменты, базисным активом которых являются ценные бумаги или фондовые индексы, полученного по результатам указанных операций, совершенных в налоговом периоде и учитываемых на индивидуальном инвестиционном счете, уменьшающая финансовый результат по операциям с производными финансовыми инструментами, обращающимися на организованном рынке, учитываемым на индивидуальном инвестиционном счете",
		, , 
		"-","-","252"); 
	
	ОписатьКодВычетаНДФЛ("Код311", "311", "Сумма, израсходованная налогоплательщиком на новое строительство либо приобретение на территории РФ жилого дома, квартиры или доли (долей) в них", Ложь, ГруппыВычетов.Имущественные,
		"311","311","311");
	ОписатьКодВычетаНДФЛ("Код312", "312", "Сумма, направленная на погашение процентов по целевым займам (кредитам) на новое строительство или приобретение на территории РФ жилого дома, квартиры", Ложь, ГруппыВычетов.Имущественные,
		"312","312","312");
	ОписатьКодВычетаНДФЛ("Код318", "318", "Сумма процентов по кредитам в целях перекредитования кредитов на новое строительство или приобретение на территории РФ жилого дома, квартиры", Ложь, ГруппыВычетов.Имущественные,
		"318","312", "312");
	ОписатьКодВычетаНДФЛ("Код319", "327", "Сумма упл-х пенс-х взносов по договору негосударственного пенсионного обеспечения и/или страх-х взносов по договору добровольного пенсионного страх-ия", Ложь, ГруппыВычетов.Социальные, 
		"319","327","327");
	ОписатьКодВычетаНДФЛ("Код320", "328", "Сумма уплаченных дополнительных страховых взносов на накопительную часть трудовой пенсии в соответствии с Федеральным законом от 30.04.2008 № 56-ФЗ", Ложь, ГруппыВычетов.Социальные,
		"620","328","328");
	
	ОписатьКодВычетаНДФЛ("Код329", "Стр.жизни", "Сумма страховых взносов по договору (договорам) добровольного страхования жизни, если такие договоры заключаются на срок не менее пяти лет, заключенному (заключенным) со страховой организацией в свою пользу и (или) в пользу супруга (в том числе вдовы, вдовца), родителей (в том числе усыновителей), детей (в том числе усыновленных, находящихся под опекой (попечительством))", 
		Ложь, ГруппыВычетов.СоциальныеПоУведомлениюНО,
		"-", "-","620");
	
	ОписатьКодВычетаНДФЛ("Код403", "403", "Сумма фактически произведенных и документально подтвержденных расходов, связанных с выполнением работ (оказанием услуг) по договорам ГПХ",
		,,"403","403","403");
	ОписатьКодВычетаНДФЛ("Код404", "404", "Сумма фактически произведенных и документально подтвержденных расходов, связанных с получением авторских вознаграждений",,,
		"404","404","404");
	ОписатьКодВычетаНДФЛ("Код405", "405", "Сумма в пределах нормативов затрат, связанных с получением авторских вознаграждений",,,
		"405","405","405");
	ОписатьКодВычетаНДФЛ("Код501", "501", "Вычет из стоимости подарков, полученных от организаций и индивидуальных предпринимателей",,,
		"501","501","501");
	ОписатьКодВычетаНДФЛ("Код502", "502", "Вычет из стоимости призов в денежной и натуральной форме на конкурсах и соревнованиях, проводимых в соотв. с решениями Прав-ва РФ и др. органов власти",,,
		"502","502","502");
	ОписатьКодВычетаНДФЛ("Код503", "503", "Вычет из суммы материальной помощи, оказываемой работодателями своим работникам, а также бывшим своим работникам-пенсионерам",,,
		"503","503","503");
	ОписатьКодВычетаНДФЛ("Код504", "504", "Вычет из суммы возмещения (оплаты) работодателями своим работникам, бывшим своим работникам (пенсионерам), а также инвалидам стоимости медикаментов",,,
		"504","504","504");
	ОписатьКодВычетаНДФЛ("Код505", "505", "Вычет из стоимости выигрышей и призов, полученных на конкурсах, играх и других мероприятиях в целях рекламы товаров (работ, услуг)",,,
		"505","505","505");
	ОписатьКодВычетаНДФЛ("Код506", "506", "Вычет из суммы материальной помощи, оказываемой инвалидам общественными организациями инвалидов",,,
		"506","506","506");
	ОписатьКодВычетаНДФЛ("Код507", "507", "Вычет из суммы помощи (в денежной и натуральной формах), а также стоимости подарков, полученных ветеранами, инвалидами ВОВ и приравненных к ним",,,
		"507","507","507");
	ОписатьКодВычетаНДФЛ("МатпомощьПриРожденииРебенка", "508", "Вычет из суммы материальной помощи, оказываемой работодателями своим работникам при рождении (усыновлении) ребенка",,,
		"508","508","508");
	ОписатьКодВычетаНДФЛ("Код509", "509", "Вычет из доходов, полученных работниками в натуральной форме в качестве оплаты труда от организаций - с/х товаропроизводителей и крестьянских х-в",,,
		"509","509","509");
	ОписатьКодВычетаНДФЛ("Код601", "601", "Сумма, уменьшающая налоговую базу по доходам, полученным в виде дивидендов",,,"601","601","601");
	ОписатьКодВычетаНДФЛ("Код607", "510", "Вычет в сумме уплаченных работодателем страховых взносов за работника на накопительную часть трудовой пенсии, но не более 12000 рублей в год",,, 
		"607","510","510");
	ОписатьКодВычетаНДФЛ("Код619", "619", "Сумма положительного финансового результата, полученного по операциям, учитываемым на индивидуальном инвестиционном счете",,,"619","619","619");
	ОписатьКодВычетаНДФЛ("Код620", "620", "Иные суммы, уменьшающие налоговую базу в соответствии с положениями главы 23 Налогового кодекса Российской Федерации",,,"620","620","620");
	
	
КонецПроцедуры

Процедура ОписатьКодВычетаНДФЛ(ИмяПредопределенныхДанных, Код, Наименование, ВычетКДоходу = Истина, ГруппаВычета = Неопределено,  Код2011 = "", Код2015 = "", Код2016 = "", НеПредоставляетсяНерезидентам = Ложь)

	СсылкаПредопределенного = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВычетыНДФЛ." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Элемент = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Элемент = Справочники.ВычетыНДФЛ.СоздатьЭлемент();
		Элемент.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;
	
	Если Элемент.Код <> Код Тогда
		Элемент.Код = Код
	КонецЕсли;
	Если Элемент.Наименование <> Наименование Тогда
		Элемент.Наименование = Наименование
	КонецЕсли;
	Если Элемент.ПолноеНаименование <> Наименование Тогда
		Элемент.ПолноеНаименование = Наименование
	КонецЕсли;
	
	Если Элемент.ВычетКДоходу <> ВычетКДоходу Тогда
		Элемент.ВычетКДоходу = ВычетКДоходу
	КонецЕсли;
	Если Элемент.ГруппаВычета <> ГруппаВычета Тогда
		Элемент.ГруппаВычета = ГруппаВычета	
	КонецЕсли;
	Если Элемент.НеПредоставляетсяНерезидентам <> НеПредоставляетсяНерезидентам Тогда
		Элемент.НеПредоставляетсяНерезидентам = НеПредоставляетсяНерезидентам	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Код2011) Тогда
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2011Года = Код2011;
	Иначе  	
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2011Года = Элемент.Код;
	КонецЕсли;

	Если ЗначениеЗаполнено(Код2015) Тогда
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2015Года = Код2015;
	Иначе  	
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2015Года = Элемент.Код;
	КонецЕсли;
	
	Если Элемент.КодПрименяемыйВНалоговойОтчетностиС2016Года <> Код2016 Тогда
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2016Года = Код2016
	КонецЕсли;
	
	
	Если Элемент.Модифицированность() Тогда
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Элемент, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли