#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//{Режим открытия окна
	#Если ВебКлиент Тогда
	ЭтоВебКлиент=Истина;
	#Иначе
	ЭтоВебКлиент=Ложь;
	#КонецЕсли
	//}
	
	Параметры.Отбор.Свойство("ВладелецТочки", ВладелецТочкиОтбор);
	
	Если ТипЗнч(ВладелецТочкиОтбор)=Тип("БизнесПроцессВыборка.КП_БизнесПроцесс") Тогда
		ТипВладельцаТочки=1;
	Иначе
		ТипВладельцаТочки=0;
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоВидыПроцессов") И Параметры.ТолькоВидыПроцессов Тогда
		Элементы.ТипВладельцаТочки.Видимость=Ложь;
		Элементы.ВладелецТочкиОтбор.ПоложениеЗаголовка=ПоложениеЗаголовкаЭлементаФормы.Лево;
		ТипВладельцаТочки=0;
	КонецЕсли;
	
	УстановитьТипВладельца(Ложь);
	
	Параметры.Отбор.Свойство("ТипТочки", ТипТочкиОтбор);
	Параметры.Отбор.Свойство("СсылкаИсключение", СсылкаИсключениеОтобр);
	
	Если ЗначениеЗаполнено(ВладелецТочкиОтбор) Тогда
		Элементы.ВладелецТочкиОтбор.ТолькоПросмотр=Истина;
		
	КонецЕсли;
	
	Элементы.Список.РежимВыбора=ЭтаФорма.Параметры.РежимВыбора;
		
	Если Параметры.Свойство("Заголовок") Тогда
		ЭтаФорма.АвтоЗаголовок=Ложь;
		ЭтаФорма.Заголовок=Параметры.Заголовок;
	КонецЕсли;
	
	ИспользоватьОтборПоТипуФормыЗадачи=Параметры.Отбор.Свойство("ТипФормыЗадачи", ТипФормыЗадачиОтбор);
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КорпоративныйПроцессПриИзменении(Элемент)
	ОбновитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписок()
	
	Список.ТекстЗапроса=ПолучитьТекстЗапроса();
	
	Список.Параметры.УстановитьЗначениеПараметра("ВладелецТочки", ?(ЗначениеЗаполнено(ВладелецТочкиОтбор), ВладелецТочкиОтбор, NULL));
	Список.Параметры.УстановитьЗначениеПараметра("ТипТочки", ?(ЗначениеЗаполнено(ТипТочкиОтбор), ТипТочкиОтбор, NULL));
	
	Если СсылкаИсключениеОтобр<>Неопределено Тогда
		Список.Параметры.УстановитьЗначениеПараметра("СсылкаИсключение", СсылкаИсключениеОтобр);
	КонецЕсли;
	
	Если ИспользоватьОтборПоТипуФормыЗадачи Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ТипФормыЗадачи", ТипФормыЗадачиОтбор);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТекстЗапроса()
	ТекстЗапроса="ВЫБРАТЬ
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.Ссылка,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ПометкаУдаления,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.Предопределенный,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.Код,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.Наименование,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ТипТочки,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ВладелецТочки,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ИмяВСхеме,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ТипУсловиеФункция,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ИсточникИсполнителей,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.РеквизитСИсполнителем,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ТекстФункции,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеТекстФункцииПослеВыполнения,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ПодпроцессВид,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ПодпроцессЖдатьОкончания,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеНеУчитыватьЗаместителей,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ТипОбработки,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеИсточникТекстаЗаданийЧисло,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ОбработкаДокументСостояние,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ОбработкаОтправитьНаПодпись,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеПараллельное,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеТипФормыЗадач,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеЗавершениеСпискаПослеОдного,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеИсполнительМожетСоздатьПодпроцесс,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеОсновнойОтчетИсполнителей,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеРеквизитыРасполагатьВДваСтолбца,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеИспользоватьНастройкуФормыИзВидаПроцесса,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеКонтрольТочки,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.УсловиеТочкаКонтроля,
		|	СправочникаДокументооборотТочкиКорпоративныхПроцессов.ТочкаОснование
		|ИЗ
		|	Справочник.КП_ТочкиПроцессов КАК СправочникаДокументооборотТочкиКорпоративныхПроцессов
		|ГДЕ
		|	(&ВладелецТочки ЕСТЬ NULL 
		|			ИЛИ СправочникаДокументооборотТочкиКорпоративныхПроцессов.ВладелецТочки = &ВладелецТочки)
		|	И (&ТипТочки ЕСТЬ NULL 
		|			ИЛИ СправочникаДокументооборотТочкиКорпоративныхПроцессов.ТипТочки = &ТипТочки)
		|	И (СправочникаДокументооборотТочкиКорпоративныхПроцессов.Ссылка <> &СсылкаИсключение)
		|";
		
		
	Если ИспользоватьОтборПоТипуФормыЗадачи Тогда
		ТекстЗапроса=ТекстЗапроса+"
			|	И СправочникаДокументооборотТочкиКорпоративныхПроцессов.ДействиеТипФормыЗадач = &ТипФормыЗадачи";
		
	КонецЕсли;
	
	Если СсылкаИсключениеОтобр<>Неопределено Тогда
		ТекстЗапроса=ТекстЗапроса+"
			|	И (СправочникаДокументооборотТочкиКорпоративныхПроцессов.Ссылка <> &СсылкаИсключение)";
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
			
КонецФункции

&НаКлиенте
Процедура ТипВладельцаТочкиПриИзменении(Элемент)
	УстановитьТипВладельца();
	ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура ВладелецТочкиОтборОчистка(Элемент, СтандартнаяОбработка)
	УстановитьТипВладельца();
КонецПроцедуры

&НаСервере
Процедура УстановитьТипВладельца(ОчищатьПоле=Истина)
	
	МассивТипов=Новый Массив();	
	
	Если ТипВладельцаТочки=0 Тогда
		МассивТипов.Добавить(Тип("СправочникСсылка.КП_ВидыПроцессов"));
	Иначе
		МассивТипов.Добавить(Тип("БизнесПроцессСсылка.КП_БизнесПроцесс"));
	КонецЕсли;
	
	ДопустимыеТипы=Новый ОписаниеТипов(МассивТипов, , );
	Элементы.ВладелецТочкиОтбор.ОграничениеТипа=ДопустимыеТипы;
	
	Если ОчищатьПоле Тогда
		Если ТипВладельцаТочки=0 Тогда
			ВладелецТочкиОтбор=Справочники.КП_ВидыПроцессов.ПустаяСсылка();
		Иначе
			ВладелецТочкиОтбор=БизнесПроцессы.КП_БизнесПроцесс.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	Если ЗначениеЗаполнено(ВладелецТочкиОтбор) Тогда
		Настройки["ВладелецТочкиОтбор"]=ВладелецТочкиОтбор;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
