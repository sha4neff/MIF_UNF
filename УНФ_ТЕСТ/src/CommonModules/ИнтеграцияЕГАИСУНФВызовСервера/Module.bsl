
#Область СлужебныеПроцедурыИФункции

Функция ДанныеАлкогольнойПродукции(Номенклатура) Экспорт
	Возврат ИнтеграцияЕГАИСУНФ.ДанныеАлкогольнойПродукции(Номенклатура);
КонецФункции

Процедура ЗаполнитьАлкогольнуюПродукцию(ТекущаяСтрока) Экспорт
	ИнтеграцияЕГАИСУНФ.ЗаполнитьАлкогольнуюПродукцию(ТекущаяСтрока);
КонецПроцедуры

Функция ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(Организация, Склад) Экспорт
	Возврат Справочники.КлассификаторОрганизацийЕГАИС.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(Организация, Склад);
КонецФункции

Функция ДанныеСопоставленияОрганизацииЕГАИС(КодВФСРАР) Экспорт
	Возврат ИнтеграцияЕГАИСПереопределяемый.ДанныеСопоставленияОрганизацииЕГАИС(КодВФСРАР);
КонецФункции

Функция КонтрагентПоОрганизацииЕГАИС(ОрганизацияЕГАИС, ТорговыйОбъект = Неопределено, СоответствуетОрганизации = Ложь, ТолькоСопоставленные = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС"        , ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("ТорговыйОбъект"          , ТорговыйОбъект);
	Запрос.УстановитьПараметр("СоответствуетОрганизации", СоответствуетОрганизации);
	Запрос.УстановитьПараметр("ТолькоСопоставленные"    , ТолькоСопоставленные);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторОрганизацийЕГАИС.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КлассификаторОрганизацийЕГАИС КАК КлассификаторОрганизацийЕГАИС
	|ГДЕ
	|	НЕ КлассификаторОрганизацийЕГАИС.ПометкаУдаления
	|	И КлассификаторОрганизацийЕГАИС.Ссылка = &ОрганизацияЕГАИС
	|	И (&ТорговыйОбъект = НЕОПРЕДЕЛЕНО
	|			ИЛИ КлассификаторОрганизацийЕГАИС.ТорговыйОбъект = &ТорговыйОбъект)
	|	И КлассификаторОрганизацийЕГАИС.СоответствуетОрганизации = &СоответствуетОрганизации
	|	И ВЫБОР
	|			КОГДА &ТолькоСопоставленные
	|				ТОГДА КлассификаторОрганизацийЕГАИС.Сопоставлено
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить()[0].Ссылка;
	
КонецФункции

Функция ДокументаЕГАИСПоОснованию(ДокументОснование, ИмяДокумента) Экспорт
	
	ДокументЕГАИС = Неопределено;
	
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТТНИсходящаяЕГАИС.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ТТНИсходящаяЕГАИС КАК ТТНИсходящаяЕГАИС
		|ГДЕ
		|	ТТНИсходящаяЕГАИС.ДокументОснование = &ДокументОснование
		|	И НЕ ТТНИсходящаяЕГАИС.ПометкаУдаления";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документ.ТТНИсходящаяЕГАИС", ИмяДокумента);
		
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ДокументЕГАИС = Выборка.Ссылка;
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	Возврат ДокументЕГАИС;
	
КонецФункции

Функция АдресКонтрагентовДляСопоставления(УникальныйИдентификатор, МассивАлкогольнойПродукции, ТТНВходящаяЕГАИС) Экспорт
	
	//Возврат ИнтеграцияЕГАИСРТ.АдресКонтрагентовДляСопоставления(УникальныйИдентификатор, МассивАлкогольнойПродукции, ТТНВходящаяЕГАИС);
	
КонецФункции

Функция АдресОрганизацийЕГАИСДляСопоставления(УникальныйИдентификатор, МассивНоменклатуры) Экспорт
	
	//Возврат ИнтеграцияЕГАИСРТ.АдресОрганизацийЕГАИСДляСопоставления(УникальныйИдентификатор, МассивНоменклатуры);
	
КонецФункции

Функция ВыгружатьПродажиНемаркируемойПродукцииВЕГАИС() Экспорт
	
	Возврат Константы.ВыгружатьПродажиНемаркируемойПродукцииВЕГАИС.Получить()
	
КонецФункции

Функция НесопоставленныеТоварыВТТН(ДокументСсылка) Экспорт
	
	ИмяТаблицы = "Документ" + "." + ДокументСсылка.Метаданные().Имя + "." + "Товары";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТабличнаяЧасть.НомерСтроки,
	|	ТабличнаяЧасть.АлкогольнаяПродукция,
	|	ТабличнаяЧасть.ИдентификаторУпаковки
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	ИмяТаблицы КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Товары.АлкогольнаяПродукция
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО Товары.АлкогольнаяПродукция = СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция
	|			И Товары.ИдентификаторУпаковки = СоответствиеНоменклатурыЕГАИС.ИдентификаторУпаковки
	|ГДЕ
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура ЕСТЬ NULL");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицы", ИмяТаблицы);
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("АлкогольнаяПродукция");
	
КонецФункции

Функция АлкогольнаяПродукцияПоНоменклатуре(Номенклатура, Характеристика) Экспорт
	
	Результат = Справочники.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	СоответствиеЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеЕГАИС
	|ГДЕ
	|	СоответствиеЕГАИС.Номенклатура = &Номенклатура
	|	И СоответствиеЕГАИС.Характеристика = &Характеристика";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.АлкогольнаяПродукция;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИспользуетсяРегистрацияРозничныхПродажВЕГАИС(Знач ДатаПродажи = Неопределено) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаПродажи) Тогда
		ДатаПродажи = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ДатаНачалаРегистрации = Константы.ДатаНачалаРегистрацииРозничныхПродажВЕГАИС.Получить();
	
	Возврат ДатаПродажи >= ДатаНачалаРегистрации И ЗначениеЗаполнено(ДатаНачалаРегистрации);

КонецФункции // ИспользуетсяРегистрацияРозничныхПродажВЕГАИС()

Функция ПолучитьШтрихкодПоНоменклатуре(СтруктураПараметров) Экспорт
	
	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьШтрихкодПоНоменклатуре(СтруктураПараметров.Номенклатура);
	
КонецФункции

#КонецОбласти
