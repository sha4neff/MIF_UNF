////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с формой документа".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция СформироватьНадписьСчетФактура(НайденныйСчетФактура, Полученный = Ложь, СчетФактураТекст="") Экспорт

	КомпонентыФС = Новый Массив;
	Если Полученный Тогда
		
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Счет-фактура (полученный): '")));
		
	Иначе
		
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Счет-фактура: '")));
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НайденныйСчетФактура) Тогда
		
		Если ТипЗнч(НайденныйСчетФактура) = Тип("Структура") Тогда
			
			НомерСФ = Неопределено;
			ДатаСФ = Неопределено;
			
			НайденныйСчетФактура.Свойство("Номер", НомерСФ);
			НайденныйСчетФактура.Свойство("Дата", ДатаСФ);
			
			Если ЗначениеЗаполнено(ДатаСФ)
				И ТипЗнч(ДатаСФ) = Тип("Дата") Тогда
				
				ДатаСФ = Формат(ДатаСФ, "ДФ=dd.MM.yyyy");
				
			КонецЕсли;
			
			СчетФактураТекст = СтрШаблон(НСтр("ru ='№ %1 от %2'"), НомерСФ, ДатаСФ);
			
		Иначе
			
			// для строки
			СчетФактураТекст = СтрЗаменить(НайденныйСчетФактура, НСтр("ru = 'Счет-фактура '"),"№");
			
		КонецЕсли;
		
		СчетФактураТекст = СтрЗаменить(СчетФактураТекст, НСтр("ru = ' (удален)'"),"");
		СчетФактураТекст = СтрЗаменить(СчетФактураТекст, НСтр("ru = ' (не проведен)'"),"");
		
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(СчетФактураТекст, , , , "открыть"));
		
	Иначе
		
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока("создать", , , , "создать"));
		
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(КомпонентыФС);
	
КонецФункции

Функция СформироватьНадписьДокументОснование(Знач ДокОснование, Знач пТолькоПросмотр = Ложь) Экспорт
	
	КомпонентыФС = Новый Массив;
	
	ПредставлениеДокОснования = РаботаСФормойДокумента.ПредставлениеДокументаОснования(ДокОснование);
	
	Если ПредставлениеДокОснования = "НетОбъекта" Тогда
		
		КомпонентыФС = Новый Массив;
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Основание: находится в автномном рабочем месте'")));
		
	ИначеЕсли ЗначениеЗаполнено(ДокОснование) Тогда
		
		// Для документов, у которых "номер входящего документа" указывается в отдельном поле, например Счет-фактура входящий
		Если ТипЗнч(ДокОснование) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
			РеквизитыДокОснования = РаботаСФормойДокумента.РеквизитыДокументаОснования(ДокОснование);
			
			ПредставлениеДокОснования = СтрЗаменить(ПредставлениеДокОснования, 
				НСтр("ru = 'Счет-фактура (полученный) '")+ПолучитьКороткийНомерДокумента(РеквизитыДокОснования.Номер),
				НСтр("ru = 'Счет-фактура (полученный) '")+РеквизитыДокОснования.НомерВходящегоДокумента);
			ПредставлениеДокОснования = СтрЗаменить(ПредставлениеДокОснования,
				Формат(РеквизитыДокОснования.Дата,"ДФ=dd.MM.yyyy"),
				Формат(РеквизитыДокОснования.ДатаВходящегоДокумента,"ДФ=dd.MM.yyyy"));
		КонецЕсли;
		
		ДокОснованиеТекст = ПредставлениеДокОснования;
		
		ДокОснованиеТекст = СтрЗаменить(ДокОснованиеТекст, НСтр("ru = ' (удален)'"),"");
		ДокОснованиеТекст = СтрЗаменить(ДокОснованиеТекст, НСтр("ru = ' (не проведен)'"),"");

		КомпонентыФС = Новый Массив;
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Основание: '")));
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(ДокОснованиеТекст, , , , "открыть"));
		Если НЕ пТолькоПросмотр Тогда
			КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(" "));
			КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.ЗаполнитьПоОснованию12х12, , , , "заполнить"));
			КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(" "));
			КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Очистить, , , , "удалить"));
		КонецЕсли;
	Иначе
		КомпонентыФС = Новый Массив;
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Основание: '")));
		КомпонентыФС.Добавить(Новый ФорматированнаяСтрока("выбрать", , , , "выбрать"));
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(КомпонентыФС);

КонецФункции

Функция ПолучитьЗаголовокПредоплаты(Знач ТабЧасть, Знач ВалютаДокумента) Экспорт
	
	Если ТабЧасть.Количество()>0 Тогда
		Возврат НСтр("ru = 'Предоплата: '") + ТабЧасть.Итог("СуммаРасчетов") + " " + УправлениеНебольшойФирмойПовтИсп.ПолучитьСимвольноеПредставлениеВалюты(ВалютаДокумента); 
	Иначе
		Возврат НСтр("ru = 'Предоплата'");
	КонецЕсли;
	
КонецФункции

Функция ПолучитьЗаголовокОплаты(Знач СпособЗачета, Знач ТабЧасть) Экспорт
	
	Если СпособЗачета = ПредопределенноеЗначение("Перечисление.СпособыЗачетаИРаспределенияПлатежей.Авто") Тогда
		Возврат НСтр("ru = 'Оплата ('") + СпособЗачета + ")";
	Иначе
		Если ТабЧасть.Количество()>0 Тогда
			Возврат НСтр("ru = 'Оплата ('") + ТабЧасть.Количество() + ")";
		Иначе
			Возврат НСтр("ru = 'Оплата ('") + СпособЗачета + ")";
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция КраткоеПредставлениеТипаНалогообложенияНДС(НалогообложениеНДС) Экспорт
	
	Если НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДС") Тогда
		Возврат НСтр("ru = 'с НДС'");
	ИначеЕсли НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.НеОблагаетсяНДС") Тогда
		Возврат НСтр("ru = 'без НДС'");
	ИначеЕсли НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.НаЭкспорт") Тогда
		Возврат НСтр("ru = '0% НДС'");
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция ПолучитьКороткийНомерДокумента(Знач НомерДок) Экспорт
	
	СоответствиеЧисел = Новый Соответствие();
	СоответствиеЧисел.Вставить("1",1);
	СоответствиеЧисел.Вставить("2",2);
	СоответствиеЧисел.Вставить("3",3);
	СоответствиеЧисел.Вставить("4",4);
	СоответствиеЧисел.Вставить("5",5);
	СоответствиеЧисел.Вставить("6",6);
	СоответствиеЧисел.Вставить("7",7);
	СоответствиеЧисел.Вставить("8",8);
	СоответствиеЧисел.Вставить("9",9);
	СоответствиеЧисел.Вставить("0",0);
	
	НомерДок = СокрЛП(НомерДок);
	ДлинаСтроки = СтрДлина(НомерДок);
	НомерЧисло = НомерДок;
	
	Для н=1 По ДлинаСтроки Цикл
	
		Если СоответствиеЧисел.Получить(Сред(НомерДок,ДлинаСтроки-н+1,1)) = Неопределено Тогда
			НомерЧисло = Прав(НомерДок, н-1); 
			Прервать;
		КонецЕсли;
	
	КонецЦикла;
	
	Если СтрДлина(НомерЧисло)>0 Тогда
		Возврат Число(НомерЧисло);
	Иначе
		Возврат НомерДок;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьИмяФормыСтрокой(Знач ИмяФормы) Экспорт
	
	ИмяФормы = СтрЗаменить(ИмяФормы, ".ФормаСписка", "");
	ИмяФормы = СтрЗаменить(ИмяФормы, ".ФормаДокумента", "");
	ИмяФормы = СтрЗаменить(ИмяФормы, ".ФормаВыбора", "");
	ИмяФормы = СтрЗаменить(ИмяФормы, ".ФормаЭлемента", "");
	ИмяФормы = СтрЗаменить(ИмяФормы, ".Форма", "");
	
	ИмяФормы = СтрЗаменить(ИмяФормы, ".", "");
	
	Возврат ИмяФормы;
	
КонецФункции

Функция ВариантОтчета(ИмяОтчета, КлючВарианта) Экспорт
	
	Возврат РаботаСФормойДокумента.СсылкаВариантаОтчета(ИмяОтчета, КлючВарианта);
	
КонецФункции

#КонецОбласти
