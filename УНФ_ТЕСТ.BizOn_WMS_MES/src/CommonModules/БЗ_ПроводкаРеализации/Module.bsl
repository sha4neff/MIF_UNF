Процедура ПровестиРеализации(ВыполнениеПогрузки)    экспорт
	СписокРеализаций=ПолучитьРеализации(ВыполнениеПогрузки);
	Недогрузы= ПолучитьНедогрузы(ВыполнениеПогрузки);
	ПараметрыСеанса.БЗ_ПроводитьБезКонтроляОстатков=Истина;

	Для каждого строка из СписокРеализаций цикл
		ПровестиПроизводство(Строка.РасходнаяНакладная, недогрузы);
		ПровестиРеализацию(строка.РасходнаяНакладная);	 
	КонецЦикла;
	
КонецПроцедуры



Функция ПолучитьРеализации(ВыполнениеПогрузки)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
"ВЫБРАТЬ
|	БЗ_ВыполнениеПогрузки.ДокументОснование.ДокументОснование КАК ГлавныйЗаказ
|ПОМЕСТИТЬ ВтГлавныйЗаказ
|ИЗ
|	Документ.БЗ_ВыполнениеПогрузки КАК БЗ_ВыполнениеПогрузки
|ГДЕ
|	БЗ_ВыполнениеПогрузки.Ссылка = &ВыполнениеПогрузки
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ВтГлавныйЗаказ.ГлавныйЗаказ КАК ГлавныйЗаказ,
|	ЗаказПокупателя.Ссылка КАК Ссылка
|ПОМЕСТИТЬ ВтЗаказы
|ИЗ
|	ВтГлавныйЗаказ КАК ВтГлавныйЗаказ
|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ЗаказПокупателя
|		ПО (ВтГлавныйЗаказ.ГлавныйЗаказ = ЗаказПокупателя.Ссылка
|				ИЛИ ВтГлавныйЗаказ.ГлавныйЗаказ = ЗаказПокупателя.БЗ_ГлавныйЗаказ)
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	РасходнаяНакладная.Ссылка КАК РасходнаяНакладная
|ИЗ
|	ВтЗаказы КАК ВтЗаказы
|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасходнаяНакладная КАК РасходнаяНакладная
|		ПО ВтЗаказы.Ссылка = РасходнаяНакладная.Заказ
|ГДЕ
|	НЕ РасходнаяНакладная.Проведен
|
|СГРУППИРОВАТЬ ПО
|	РасходнаяНакладная.Ссылка";
;
	
	Запрос.УстановитьПараметр("ВыполнениеПогрузки", ВыполнениеПогрузки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
	
КонецФункции


Функция ПолучитьНедогрузы(ВыполнениеПогрузки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БЗ_ЗаданиеНаПогрузкуТовары.Ссылка КАК Ссылка,
	|	БЗ_ЗаданиеНаПогрузкуТовары.Номенклатура КАК Номенклатура,
	|	БЗ_ЗаданиеНаПогрузкуТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	СУММА(БЗ_ЗаданиеНаПогрузкуТовары.Количество) КАК Количество,
	|	СУММА(БЗ_ВыполнениеПогрузкиТовары.Количество) КАК КоличествоПогружено
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ
	|	Документ.БЗ_ВыполнениеПогрузки.Товары КАК БЗ_ВыполнениеПогрузкиТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БЗ_ЗаданиеНаПогрузку.Товары КАК БЗ_ЗаданиеНаПогрузкуТовары
	|		ПО БЗ_ВыполнениеПогрузкиТовары.Ссылка.ДокументОснование = БЗ_ЗаданиеНаПогрузкуТовары.Ссылка
	|ГДЕ
	|	БЗ_ВыполнениеПогрузкиТовары.Ссылка = &ВыполнениеПогрузки
	|
	|СГРУППИРОВАТЬ ПО
	|	БЗ_ЗаданиеНаПогрузкуТовары.Ссылка,
	|	БЗ_ЗаданиеНаПогрузкуТовары.ХарактеристикаНоменклатуры,
	|	БЗ_ЗаданиеНаПогрузкуТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТовары.Номенклатура КАК Номенклатура,
	|	ВТТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	СУММА(ВТТовары.Количество - ВТТовары.КоличествоПогружено) КАК Поле1
	|ПОМЕСТИТЬ ВтНедогрузы
	|ИЗ
	|	ВТТовары КАК ВТТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТТовары.Номенклатура,
	|	ВТТовары.ХарактеристикаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВтНедогрузы.Номенклатура КАК Номенклатура,
	|	ВтНедогрузы.ХарактеристикаНоменклатуры КАК Характеристика,
	|	ВтНедогрузы.Поле1 КАК Количество
	|ИЗ
	|	ВтНедогрузы КАК ВтНедогрузы
	|ГДЕ
	|	ВтНедогрузы.Поле1 <> 0";
	
	Запрос.УстановитьПараметр("ВыполнениеПогрузки", ВыполнениеПогрузки);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат  РезультатЗапроса.Выгрузить();
	
	
КонецФункции

Процедура ПровестиПроизводство(Реализация, недогрузы)
	докПроизводства= Документы.СборкаЗапасов.СоздатьДокумент();
	докПроизводства.Дата=Реализация.ссылка.дата-300;
	докПроизводства.ВидОперации=Перечисления.ВидыОперацийСборкаЗапасов.Сборка;
	докПроизводства.Комментарий="Заказ покупателя "+Реализация.заказ.номер + " от "+ Реализация.заказ.дата;
	докПроизводства.Организация=Справочники.Организации.НайтиПоКоду("НФ-000002");
	докПроизводства.СтруктурнаяЕдиница=Справочники.СтруктурныеЕдиницы.НайтиПоКоду("НФ-000014");
	докПроизводства.СтруктурнаяЕдиницаПродукции=Справочники.СтруктурныеЕдиницы.НайтиПоКоду("00-000001");
	сч=1;
	Для каждого стр из Реализация.заказ.запасы цикл
		Если стр.номенклатура.изготовитель=докПроизводства.СтруктурнаяЕдиница тогда
			новстр=докПроизводства.Продукция.Добавить();
			ЗаполнитьЗначенияСвойств(новстр, стр);	
			новстр.КлючСвязи=сч;
			сч=сч+1;	
		КонецЕсли;	
	КонецЦикла;	
	Если сч<>1 Тогда 
		докПроизводства.ЗаполнитьТабличнуюЧастьПоСпецификации();
		докПроизводства.ПоложениеСклада=Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти;
		Для каждого стр из докпроизводства.Запасы цикл
			стр.СтруктурнаяЕдиница=стр.Номенклатура.Изготовитель.ПолучательПеремещения;
			структураПоиска= Новый Структура();
			структураПоиска.Вставить("Номенклатура", стр.Номенклатура);
			структураПоиска.Вставить("Характеристика",стр.Характеристика);
			строки=Недогрузы.найтиСтроки(СтруктураПоиска);
			Для каждого строка из строки цикл
				Если строка.количество>0 тогда 
					Если стр.Количество<строка.количество Тогда
						строка.количество=строка.Количество-стр.Количество;
						стр.Количество=0;
					иначе
						строка.количество=0;
						стр.Количество=стр.Количество-строка.количество;
					КонецЕсли;	
				КонецЕсли;		
			КонецЦикла;
			если стр.номенклатура.способПополнения=Перечисления.СпособыПополненияЗапасов.Закупка Тогда
				стр.структурнаяЕдиница=справочники.СтруктурныеЕдиницы.НайтиПоКоду("НФ-000004");	
			
		Иначе
			     стр.структурнаяЕдиница=Справочники.СтруктурныеЕдиницы.НайтиПоКоду("00-000001");
		КонецЕсли;

			стр.резерв=0;
		КонецЦикла;
		докПроизводства.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
	
КонецПроцедуры


Процедура ПровестиРеализацию(Реализация)
	ДокРеализация=   Реализация.ссылка.ПолучитьОбъект();
	Для каждого стр из ДокРеализация.Запасы цикл
		если стр.номенклатура.способПополнения=Перечисления.СпособыПополненияЗапасов.Закупка Тогда
				стр.структурнаяЕдиница=справочники.СтруктурныеЕдиницы.НайтиПоКоду("НФ-000004");				
		Иначе
			     стр.структурнаяЕдиница=Справочники.СтруктурныеЕдиницы.НайтиПоКоду("00-000001");
		КонецЕсли;

		стр.резерв=0;
	КонецЦикла;
	докРеализация.ПоложениеСклада=Перечисления.ПоложениеРеквизитаНаФорме.ВТабличнойЧасти;
	ДокРеализация.Записать(РежимЗаписидокумента.Проведение);
КонецПроцедуры

